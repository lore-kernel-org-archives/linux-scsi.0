From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Wed, 10 Dec 2014 15:48:45 -0500
Message-ID: <yq11to7dydu.fsf@sermon.lab.mkp.net>
References: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 17:46:41 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

@@ -1373,20 +1380,30 @@ _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+

Why are you reverting to iterating over the queues? A while back I fixed
this up so it wouldn't fail when nr_cpus > the number of reply queues.

-- 
Martin K. Petersen	Oracle Linux Engineering
