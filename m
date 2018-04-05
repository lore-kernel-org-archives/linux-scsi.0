From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: *** SPAM *** Re: [RFC PATCH] mpt3sas:
 mpt3sas_scsih_enclosure_find_by_handle can be static
Date: Thu, 5 Apr 2018 13:43:55 +0200
Message-ID: <8e5f96f8-0072-25b8-6403-6f93d4836131@uls.co.za>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
 <20180320210652.GA40906@xian>
 <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com>
 <yq1370jj278.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1370jj278.fsf@oracle.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "lkp@intel.com" <lkp@intel.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Further to that, in the second last hunk there is a very clear
functionality change:

@@ -8756,12 +8859,12 @@ _scsih_mark_responding_expander(struct
MPT3SAS_ADAPTER *ioc,
                        continue;
                sas_expander->responding = 1;

-               if (!encl_pg0_rc)
+               if (enclosure_dev) {
                        sas_expander->enclosure_logical_id =
-                           le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-
-               sas_expander->enclosure_handle =
-                   le16_to_cpu(expander_pg0->EnclosureHandle);
+                           le64_to_cpu(enclosure_dev->pg
0.EnclosureLogicalID);
+                       sas_expander->enclosure_handle =
+                           le16_to_cpu(expander_pg0->EnclosureHandle);
+               }

                if (sas_expander->handle == handle)
                        goto out;

Note that the assignment to sas_expander->enclosure_handle is now
dependent on enclosure_dev being non-NULL.

Busy applying the patch to 4.16 - and now I have no idea whether that
functionality change should be part of the change or not.  Having worked
through the rest of the patch it seems good otherwise (Keeping in mind
that I'm not familiar with the code in question, nor do I normally work
on kernel code, and this is definitely the first time I took a peek
anywhere near the IO subsystem).

Kind Regards,
Jaco

On 28/03/2018 23:54, Martin K. Petersen wrote:
> Bart,
>
>> Are you aware that if the 0-day test infrastructure suggests an improvement
>> for a patch that the patch that that improvement applies to gets ignored
>> unless either the patch is reposted with the improvement applied or that it
>> is explained why the suggested improvement is inappropriate?
> Correct. I don't apply anything that causes a 0-day warning. The patch
> will be closed with "Changes Required" status in patchwork.
>
> Always build patch submissions to linux-scsi with:
>
> 	make C=1 CF="-D__CHECK_ENDIAN__"
>
