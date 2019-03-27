From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2] scsi: qla2xxx: Simplify conditional check again
Date: Wed, 27 Mar 2019 10:01:42 -0700
Message-ID: <CAKwvOdkLJaO3H25JU19qPtMe=LTJmxUicPvE=vWOKw7nqDC=-Q@mail.gmail.com>
References: <20190320163315.12740-1-natechancellor@gmail.com> <20190326220444.10040-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326220444.10040-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Carnuccio <joe.carnuccio@cavium.com>, Himanshu Madhani <hmadhani@marvell.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 26, 2019 at 3:06 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when it sees a logical not on the left side of a
> conditional statement because it thinks the logical not should
> be applied to the whole statement, not just the left side:
>
> drivers/scsi/qla2xxx/qla_nx.c:3703:7: warning: logical not is only
> applied to the left hand side of this comparison
> [-Wlogical-not-parentheses]
>
> This particular instance was already fixed by commit 0bfe7d3cae58 ("scsi:
> qla2xxx: Simplify conditional check") upstream but it was reintroduced
> by commit 3695310e37b4 ("scsi: qla2xxx: Update flash read/write
> routine") in the 5.2/scsi-queue.

Nathan, thanks for following up and rewording the commit message to
clearly state how we got here.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Fixes: 3695310e37b4 ("scsi: qla2xxx: Update flash read/write routine")
> Link: https://github.com/ClangBuiltLinux/linux/issues/80
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> v1 -> v2:
>
> * Reword commit message so make it clear this is just a reapplication of
>   a commit that is already in mainline, as suggested by Nick.
>
> * Include the authors who reintroduced this warning.
>
>  drivers/scsi/qla2xxx/qla_nx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index e0b4387fd6ba..359ebb634d96 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -3700,8 +3700,8 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
>                 spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>                 /* Wait for pending cmds (physical and virtual) to complete */
> -               if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
> -                   WAIT_HOST) == QLA_SUCCESS) {
> +               if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
> +                   WAIT_HOST)) {
>                         ql_dbg(ql_dbg_init, vha, 0x00b3,
>                             "Done wait for "
>                             "pending commands.\n");
> --
> 2.21.0
>


-- 
Thanks,
~Nick Desaulniers
