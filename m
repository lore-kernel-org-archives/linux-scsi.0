From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 03/15] scsi: ufs: implement scsi host timeout handler
Date: Tue, 1 Mar 2016 15:29:42 +0800
Message-ID: <56D544E6.8040005@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> A race condition exists between request requeueing and scsi layer
> error handling:
> When UFS driver queuecommand returns a busy status for a request,
> it will be requeued and its tag will be freed and set to -1.
> At the same time it is possible that the request will timeout and
> scsi layer will start error handling for it. The scsi layer reuses
> the request and its tag to send error related commands to the device,
> however its tag is no longer valid.
Hmm. How can the host return a 'busy' status for a request?
=46rom my understanding we have three possibilities:

1) queuecommand returns busy; however, that means that the command has
never been send and this issue shouldn't occur
2) The command returns with BUSY status. But in this case it has alread=
y
been returned, so there cannot be any timeout coming in.
3) The host receives a command with a tag which is already in-use.
However, that should have been prevented by the block-layer, which
really should ensure that this situation never happens.

So either way I look at it, it really looks like a bug and adding a
timeout handler will just paper over it.
(Not that a timeout handler is a bad idea, in fact I'm convinced that
you need one. Just not for this purpose.)

So can you elaborate how this 'busy' status comes about?
Is the command sent to the device?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
