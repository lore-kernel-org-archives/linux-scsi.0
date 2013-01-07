From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] iscsi-target: Fix bug in handling of ExpStatSN ACK during
 u32 wrap-around
Date: Mon, 7 Jan 2013 11:39:12 -0800
Message-ID: <CAL1RGDVJcTTGxq-XHuU3m-SDsePyx8B99tL9Fh-UKMo93D+71g@mail.gmail.com>
References: <1356557415.23065.0.camel@deadeye.wl.decadent.org.uk> <1356557611.23065.4.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:47654 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755406Ab3AGTje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2013 14:39:34 -0500
Received: by mail-we0-f197.google.com with SMTP id t11so17078539wey.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jan 2013 11:39:32 -0800 (PST)
In-Reply-To: <1356557611.23065.4.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Hodgson <steve@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Wed, Dec 26, 2012 at 1:33 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>               if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
>> -                  (cmd->cmd_sn >= conn->sess->exp_cmd_sn)) {
>> +                  iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
>>                       list_del(&cmd->i_conn_node);
>>                       spin_unlock_bh(&conn->cmd_lock);
>>                       iscsit_free_cmd(cmd);
> [...]
>
> This changes cmd->cmd_sn to cmd->stat_sn, but the commit message only
> describes fixes to wrap-around.  Is that another fix or a bug?

Great catch, thanks!  This is indeed a bug introduced by the patch.
I'll send out a fix; I guess you could roll it up into this patch, but
I'm not sure any of this stuff is worth getting into 3.2.

 - R.
