From: Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH V2] mpt3sas: support target smid for [abort|query] task
Date: Tue, 16 Jul 2019 14:44:12 +0900
Message-ID: <20190716054412epcms2p76849500e9450ac399bb123fc9b345c23@epcms2p7>
References: <860cc8cf-6419-c649-b2d9-19b82f6ebc99@suse.de>
        <20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p2>
        <CGME20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p7>
Reply-To: minwoo.im@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <860cc8cf-6419-c649-b2d9-19b82f6ebc99@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Minwoo Im <minwoo.im@samsung.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sungjun Park <sj1228.park@samsung.com>, "minwoo.im.dev@gmail.com" <minwoo.im.dev@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> I think this is fundamentally wrong.
> ABORT_TASK is used to abort a single task, which of course has to be
> known beforehand. If you don't know the task, what exactly do you hope
> to achieve here? Aborting random I/O?
> Or, even worse, aborting I/O the driver uses internally and corrupt the
> internal workflow of the driver?

This patch is nothing but a case-addition to the existing code.  I also
have a doubt here why the first picked SMID should be aborted/queried,
but not for this time in this patch.

> 
> We should simply disallow any ABORT TASK from userspace if the TaskMID
> is zero. And I would even argue to disabllow ABORT TASK from userspace
> completely, as the smid is never relayed to userland, and as such the
> user cannot know which task should be aborted.

System administrator might want to query task or abort task if something
happens based on the tag in block layer via debugfs or some logs.
You're right that userspaces has nothing to do with the tag generation
which will be held inside block layer.  But some of administrator would
know the relationship between smid and tag which can be found at debugfs
or the logs.

I'm not sure if it's okay to be picked, but if we can request TMF for the
Targeted smid to the HBA firmware, it would be great to test devices or
Figure out what happened in the target device.

Thanks,
