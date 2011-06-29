From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/15] bfa: Extend BSG interface.
Date: Wed, 29 Jun 2011 17:21:04 -0500
Message-ID: <1309386064.13937.18.camel@mulgrave>
References: <1308972315-8296-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56941 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1F2WVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2011 18:21:07 -0400
In-Reply-To: <1308972315-8296-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, huangj@brocade.com, adapter_linux_open_src_team@brocade.com

On Fri, 2011-06-24 at 20:25 -0700, kgudipat@brocade.com wrote:
>  int
>  bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
>  {
> @@ -511,27 +986,87 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned
> int cmd, void *iocmd,
>         int rc = EINVAL;

This is nastily counterintuitive.  I know it's compensated for by the

return -rc;

But you're creating code confusion here.  Some of your routines now have
a positive error return and some negative.  Can't you just keep it
negative as is the kernel convention?

James


