From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 03/17] scsi: ufs: implement scsi host timeout handler
Date: Tue, 8 Mar 2016 14:01:23 +0100
Message-ID: <56DECD23.7090704@suse.de>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
 <1457440568-13084-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 03/08/2016 01:35 PM, Yaniv Gardi wrote:
> A race condition exists between request requeueing and scsi layer
> error handling:
> When UFS driver queuecommand returns a busy status for a request,
> it will be requeued and its tag will be freed and set to -1.
> At the same time it is possible that the request will timeout and
> scsi layer will start error handling for it. The scsi layer reuses
> the request and its tag to send error related commands to the device,
> however its tag is no longer valid.
> As this request was never really sent to the device, there is no
> point to start error handling with the device.
> Implement the scsi error handling timeout callback and bypass SCSI
> error handling for request that were not actually sent to the device.
> For such requests simply reset the block layer timer. Otherwise, let
> SCSI layer perform the usual error handling.
>=20
> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>=20
Having a timeout handler is always a good idea, even though this
doesn't do anything here.
Are we sure that the requests will return eventually?
Does the UFS spec provide for a command abort?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
