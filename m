From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Wed, 10 Dec 2014 15:52:58 -0500
Message-ID: <yq1wq5zcjmd.fsf@sermon.lab.mkp.net>
References: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 18:57:23 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

@@ -2486,9 +2486,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	/* command line tunables  for max sgl entries */
 	if (max_sgl_entries != -1) {
-		ioc->shost->sg_tablesize = (max_sgl_entries <
-		    MPT2SAS_SG_DEPTH) ? max_sgl_entries :
-		    MPT2SAS_SG_DEPTH;
+		if (max_sgl_entries > MPT2SAS_SG_DEPTH)
+			printk(MPT2SAS_WARN_FMT
+			 "setting max_sgl_entries(%d), overriding kernel"
+			 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+			  max_sgl_entries, MPT2SAS_SG_DEPTH);
+		ioc->shost->sg_tablesize =  min_t(unsigned short,
+			     max_sgl_entries, SCSI_MAX_SG_CHAIN_SEGMENTS);
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}

Wouldn't it be better to print the new scatterlist limit after it has
been clamped to reflect what it's actually being set to?

-- 
Martin K. Petersen	Oracle Linux Engineering
