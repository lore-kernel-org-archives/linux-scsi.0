From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 08:16:45 +0100
Message-ID: <AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1BNHTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 02:19:38 -0500
Received: by iyj8 with SMTP id 8so4514830iyj.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 23:19:38 -0800 (PST)
In-Reply-To: <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org

On Thu, Feb 10, 2011 at 1:21 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> + =A0 =A0 =A0 switch (cmd->task_attr) {
> + =A0 =A0 =A0 case SRP_SIMPLE_TASK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 attr =3D MSG_SIMPLE_TAG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SRP_ORDERED_TASK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 attr =3D MSG_ORDERED_TAG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SRP_HEAD_TASK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 attr =3D MSG_HEAD_TAG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "Task attribute %d =
not supported\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cmd->task_attr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 attr =3D MSG_SIMPLE_TAG;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 data_len =3D srp_data_length(cmd, srp_cmd_direction(cmd=
));
> +
> + =A0 =A0 =A0 se_cmd =3D &vsc->se_cmd;
> +
> + =A0 =A0 =A0 transport_init_se_cmd(se_cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->se=
_tpg.se_tpg_tfo,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 adapter->se=
_sess, data_len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_cmd_dir=
ection(cmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attr, vsc->=
sense_buf);

Hi Tomo,

Are you sure that it is fine to pass values like MSG_SIMPLE_TAG as the
sixth argument of transport_init_se_cmd() ? As far as I know TCM
doesn' t support any of the MSG_..._TAG values.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
