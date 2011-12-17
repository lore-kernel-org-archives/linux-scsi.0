From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 14/24] libsas: prevent double completion of scmds from
 eh
Date: Sat, 17 Dec 2011 17:13:14 +0400
Message-ID: <4EEC956A.2080308@mvista.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6> <20111217023420.15036.51486.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217023420.15036.51486.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17-12-2011 6:34, Dan Williams wrote:

> We invoke task->task_done() to free the task in the eh case, but at t=
his
> point we are prepared for scsi_eh_flush_done_q() to finish off the sc=
md.

> Introduce sas_end_task() to capture the final response status from th=
e
> lldd and free the task.

> Also take the opportunity to kill this warning.
> drivers/scsi/libsas/sas_scsi_host.c: In function =E2=80=98sas_end_tas=
k=E2=80=99:
> drivers/scsi/libsas/sas_scsi_host.c:102:3: warning: case value =E2=80=
=982=E2=80=99 not in enumerated type =E2=80=98enum exec_status=E2=80=99=
 [-Wswitch]

    Perhaps this a material for a separate patch...

> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c |   61 +++++++++++++++++++-----=
-----------
>   include/scsi/libsas.h               |    5 ++-
>   2 files changed, 37 insertions(+), 29 deletions(-)

> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 6064f82..b6b0b99 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -443,7 +443,10 @@ enum service_response {
>   };
>
>   enum exec_status {
> -	/* The SAM_STAT_.. codes fit in the lower 6 bits */
> +	/* The SAM_STAT_.. codes fit in the lower 6 bits, alias some of
> +	 * them here to silence 'case value not in enumerated type' warning=
s
> +	 */
> +	__SAM_STAT_CHECK_CONDITION =3D SAM_STAT_CHECK_CONDITION,

    Looks like you forgot to change the problematic *case* itself...

MBR, Sergei
