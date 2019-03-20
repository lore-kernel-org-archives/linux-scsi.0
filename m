From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: qla2xxx: Simplify conditional check
Date: Wed, 20 Mar 2019 10:08:06 -0700
Message-ID: <CAKwvOd=-vD5_Et6i1CcoQEEX7PecOUPctjn3vsi0hHOxUDkYRw@mail.gmail.com>
References: <20190320163315.12740-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320163315.12740-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 20, 2019 at 9:36 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang generates a warning when it sees a logical not followed by a
> conditional operator like ==, >, or < because it thinks that the logical
> not should be applied to the whole statement:
>
> drivers/scsi/qla2xxx/qla_nx.c:3702:7: warning: logical not is only
> applied to the left hand side of this comparison
> [-Wlogical-not-parentheses]
>                 if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
>                     ^
> drivers/scsi/qla2xxx/qla_nx.c:3702:7: note: add parentheses after the
> '!' to evaluate the comparison first
>                 if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
>                     ^
>                      (
> drivers/scsi/qla2xxx/qla_nx.c:3702:7: note: add parentheses around left
> hand side expression to silence this warning
>                 if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
>                     ^
>                     (
> 1 warning generated.
>
> It assumes the author might have made a mistake in their logic:
>
> if (!a == b) -> if (!(a == b))
>
> Sometimes that is the case; other times, it's just a super convoluted
> way of saying 'if (a)' when b = 0:
>
> if (!1 == 0) -> if (0 == 0) -> if (true)
>
> Alternatively:
>
> if (!1 == 0) -> if (!!1) -> if (1)
>
> Simplify this comparison so that Clang doesn't complain.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/80
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> This is commit 0bfe7d3cae58 ("scsi: qla2xxx: Simplify conditional check")
> upstream but commit 3695310e37b4 ("scsi: qla2xxx: Update flash
> read/write routine") in the 5.2/scsi-queue branch silently reverted it.
> I don't care if it is squashed or not, I just want the warning to stay
> fixed.

This is probably a simpler commit message. A "Fixes:" tag is a simple
enough addition, too.
Thanks for catching this and resending the fix.

>
> Thanks,
> Nathan
>
>  drivers/scsi/qla2xxx/qla_nx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index de2bc78449e7..121e18b3b9f8 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -3699,8 +3699,8 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
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
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To post to this group, send email to clang-built-linux@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20190320163315.12740-1-natechancellor%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.



-- 
Thanks,
~Nick Desaulniers
