From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 09/15] scsi: ufs: add error recovery after DL NAC error
Date: Tue, 1 Mar 2016 15:51:55 +0800
Message-ID: <56D54A1B.8080008@suse.de>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
 <1456666367-11418-10-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-10-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
> Some vendor's UFS device sends back to back NACs for the DL data fram=
es
> causing the host controller to raise the DFES error status. Sometimes
> such UFS devices send back to back NAC without waiting for new
> retransmitted DL frame from the host and in such cases it might be
> possible the Host UniPro goes into bad state without raising the DFES
> error interrupt. If this happens then all the pending commands would
> timeout only after respective SW command (which is generally too
> large).
>=20
> This change workarounds such device behaviour like this:
> - As soon as SW sees the DL NAC error, it would schedule the error
>   handler
> - Error handler would sleep for 50ms to see if there any fatal errors
>   raised by UFS controller.
>    - If there are fatal errors then SW does normal error recovery.
>    - If there are no fatal errors then SW sends the NOP command to
>      device to check if link is alive.
>        - If NOP command times out, SW does normal error recovery
>        - If NOP command succeed, skip the error handling.
>=20
> If DL NAC error is seen multiple times with some vendor's UFS devices
> then enable this quirk to initiate quick error recovery and also
> silence related error logs to reduce spamming of kernel logs.
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/scsi/ufs/ufshcd.c | 93 +++++++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/ufs/ufshci.h |  2 +
>  2 files changed, 95 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
