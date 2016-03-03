From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 03/15] scsi: ufs: implement scsi host timeout handler
Date: Thu, 3 Mar 2016 15:22:58 +0800
Message-ID: <56D7E652.90401@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-4-git-send-email-ygardi@codeaurora.org>
 <56D544E6.8040005@suse.de>
 <2b8282aad0b3edfaf873628edf03513d.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <2b8282aad0b3edfaf873628edf03513d.squirrel@us.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: ygardi@codeaurora.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 03/01/2016 09:25 PM, ygardi@codeaurora.org wrote:
>> On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
>>> A race condition exists between request requeueing and scsi layer
>>> error handling:
>>> When UFS driver queuecommand returns a busy status for a request,
>>> it will be requeued and its tag will be freed and set to -1.
>>> At the same time it is possible that the request will timeout and
>>> scsi layer will start error handling for it. The scsi layer reuses
>>> the request and its tag to send error related commands to the devic=
e,
>>> however its tag is no longer valid.
>> Hmm. How can the host return a 'busy' status for a request?
>> From my understanding we have three possibilities:
>>
>> 1) queuecommand returns busy; however, that means that the command h=
as
>> never been send and this issue shouldn't occur
>> 2) The command returns with BUSY status. But in this case it has alr=
eady
>> been returned, so there cannot be any timeout coming in.
>> 3) The host receives a command with a tag which is already in-use.
>> However, that should have been prevented by the block-layer, which
>> really should ensure that this situation never happens.
>>
>> So either way I look at it, it really looks like a bug and adding a
>> timeout handler will just paper over it.
>> (Not that a timeout handler is a bad idea, in fact I'm convinced tha=
t
>> you need one. Just not for this purpose.)
>>
>> So can you elaborate how this 'busy' status comes about?
>> Is the command sent to the device?
>>
>> Cheers,
>>
>> Hannes
>=20
>=20
> Hi Hannes,
>=20
> it's going to be a bit long :)
> I think you are missing the point.
> I will describe a race condition happened to us a while ago, that was
> quite difficult to understand and fix.
> So, this patch is not about the "busy" returning to the scsi dispatch
> routine. it's about the abort triggered after 30 seconds.
>=20
> imagine a request being queued and sent to the scsi, and then to the =
ufs.
> a timer, initialized to 30 seconds start ticking.
> but the request is never sent to the ufs device, as queuecommand() re=
turns
> with "SCSI_MLQUEUE_HOST_BUSY"
> by looking at the code, this could happen, for example:
> 	err =3D ufshcd_hold(hba, true);
> 	if (err) {
> 		err =3D SCSI_MLQUEUE_HOST_BUSY;
> 		goto out;
> 	}
>=20
Uuhhh.
You probably should not have pointed me to that piece of code ...
open-coding loops in ufshcd_hold() ... shudder.
(Did I ever review that one? Must've ...)
_Anyway_: sleeping in queuecommand is always a bad idea, as then
precisely those issues you've just described will happen.

Couldn't you just call
ufshcd_hold(hba, false)
instead of
ufshcd_hold(hba, true)
?
The request will be requeued more-or-less immediately, avoiding the
issue with timeout handler kicking in.
And the queue will remain blocked until the ungate work item returns, a=
t
which point I/O submission will continue.
As the request will be requeued to the head of the queue there won't be
other I/O competing with tags, so it shouldn't have any adverse effects=
=2E

Wouldn't that work?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
