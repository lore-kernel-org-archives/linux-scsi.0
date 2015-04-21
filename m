From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 4/4] target/file: enable WRITE SAME when protection info
 is enabled
Date: Tue, 21 Apr 2015 20:44:16 +0900
Message-ID: <CAC5umyg+XK9T6rAq_Db=jq15Ft6ahAtncVZJV7cxHGWz8OmLbA@mail.gmail.com>
References: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
	<1429572982-6809-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429572982-6809-5-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2015-04-21 8:36 GMT+09:00 Akinobu Mita <akinobu.mita@gmail.com>:
> Now we can generate correct PI for WRITE SAME command, so it is
> unnecessary to disallow WRITE SAME when protection info is enabled.

I noticed that this patch has multiple problems.

> @@ -381,11 +381,6 @@ fd_execute_write_same(struct se_cmd *cmd)
>                 target_complete_cmd(cmd, SAM_STAT_GOOD);
>                 return 0;
>         }
> -       if (cmd->prot_op) {
> -               pr_err("WRITE_SAME: Protection information with FILEIO"
> -                      " backends not supported\n");
> -               return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -       }
>
>         if (cmd->t_data_nents > 1 ||
>             cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
> @@ -401,6 +396,14 @@ fd_execute_write_same(struct se_cmd *cmd)
>         if (!bvec)
>                 return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>
> +       if (cmd->prot_op) {
> +               ret = fd_do_rw(cmd, fd_dev->fd_prot_file, se_dev->prot_length,
> +                               cmd->t_prot_sg, cmd->t_prot_nents,
> +                               cmd->prot_length, 0);

The last argument should be '1' as this is write. and we need to
perform DIF verify
before writing.
