Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B63EC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DBB7613CB
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhFANF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:05:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41094 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhFANF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:05:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2ED3321914;
        Tue,  1 Jun 2021 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622552625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPjKU6pj8PDoi30BYRsGWXijIGqw4qsTYt4iRQdrPdg=;
        b=FB1aWO7GaXHIglo2xk130zxOboVpgCsq3n7IUJFF1rjv8f0vYGrq6yVsk14JTWoyUBz8Ug
        BAhtOAyGK/k0j6XXCQqKmmvyZX7PxCPEBzrl/c6A6JO34Mrjr3qfl3Z4Ln8zUCGfaIi2+X
        KhpGm/YnJai8c2PAN8LDKG+s1ZlIBzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622552625;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPjKU6pj8PDoi30BYRsGWXijIGqw4qsTYt4iRQdrPdg=;
        b=cPV2yRBi/6TKkvvmaF3YCccjRDpOk+lBVmqsPo0WZZMB7bRzuA/qPJ967Nr+xyKcq2cqg9
        DU36enj5zxoE6iAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 116B1118DD;
        Tue,  1 Jun 2021 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622552625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPjKU6pj8PDoi30BYRsGWXijIGqw4qsTYt4iRQdrPdg=;
        b=FB1aWO7GaXHIglo2xk130zxOboVpgCsq3n7IUJFF1rjv8f0vYGrq6yVsk14JTWoyUBz8Ug
        BAhtOAyGK/k0j6XXCQqKmmvyZX7PxCPEBzrl/c6A6JO34Mrjr3qfl3Z4Ln8zUCGfaIi2+X
        KhpGm/YnJai8c2PAN8LDKG+s1ZlIBzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622552625;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPjKU6pj8PDoi30BYRsGWXijIGqw4qsTYt4iRQdrPdg=;
        b=cPV2yRBi/6TKkvvmaF3YCccjRDpOk+lBVmqsPo0WZZMB7bRzuA/qPJ967Nr+xyKcq2cqg9
        DU36enj5zxoE6iAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id NYbuAjEwtmC3bwAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 13:03:45 +0000
Subject: Re: [PATCH v2 06/10] qla2xxx: Add authentication pass + fail bsg's
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-7-njavali@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <ec1febd6-5974-74d1-f1fb-c93f968a0420@suse.de>
Date:   Tue, 1 Jun 2021 15:03:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531070545.32072-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 9:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> On completion of the authentication process, the authentication
> application will notify driver on whether it is successful or not.
> 
> If success, application will use the QL_VND_SC_AUTH_OK BSG call
> to tell driver to proceed to the PRLI phase.
> 
> If fail, application will use the QL_VND_SC_AUTH_FAIL bsg call
> to tell driver to tear down the connection and retry. In
> the case where an existing session is active, the re-key
> process can fail. The session tear down ensure data is not
> further compromise.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_edif.c | 214 ++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
>  drivers/scsi/qla2xxx/qla_init.c |   3 +-
>  3 files changed, 216 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
