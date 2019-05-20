From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in ses_enclosure_data_process()
Date: Mon, 20 May 2019 12:05:38 -0400
Message-ID: <yq1zhnh8625.fsf@oracle.com>
References: <20190501180535.26718-1-longman@redhat.com>
        <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
        <1558363938.3742.1.camel@linux.ibm.com>
        <3385cf54-7b6c-3f28-e037-f0d4037368eb@redhat.com>
        <1558367212.3742.10.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1558367212.3742.10.camel@linux.ibm.com> (James Bottomley's
        message of "Mon, 20 May 2019 08:46:52 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>
Cc: Waiman Long <longman@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


James,

> Please.  What I'm interested in is whether this is simply a bug in the
> array firmware, in which case the fix is sufficient, or whether
> there's some problem with the parser, like mismatched expectations
> over added trailing nulls or something.

Our support folks have been looking at this for a while. We have seen
problems with devices from several vendors. To the extent that I gave up
the idea of blacklisting all of them.

I am collecting "bad" SES pages from these devices. I have added support
for RECEIVE DIAGNOSTICS to scsi_debug and added a bunch of deliberately
broken SES pages so we could debug this.

It appears to be very common for devices to return inconsistent or
invalid data. So pretty much all of the ses.c parsing needs to have
sanity checking heuristics added to prevent KASAN hiccups.

-- 
Martin K. Petersen	Oracle Linux Engineering
