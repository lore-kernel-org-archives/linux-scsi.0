Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60005C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B0642250E
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502120AbgLNQrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:47:18 -0500
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:46500 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502118AbgLNQrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 11:47:18 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 6CA581730873;
        Mon, 14 Dec 2020 16:46:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: look56_4507fd12741c
X-Filterd-Recvd-Size: 2092
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Mon, 14 Dec 2020 16:46:31 +0000 (UTC)
Message-ID: <ade665cbfa138d1851343576caad84a61e904c46.camel@perches.com>
Subject: Re: [PATCH v2 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
From:   Joe Perches <joe@perches.com>
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 08:46:30 -0800
In-Reply-To: <20201214161502.13440-2-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
         <20201214161502.13440-2-huobean@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 17:14 +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Current EM macro definition, we use stringize operator '#', which turns
> the argument it precedes into a quoted string. Thus requires the symbol
> of __print_symbolic() should be the string corresponding to the name of
> the enum.
> 
> However, we have other cases, the symbol and enum name are not the same,
> we can redefine EM/EMe, but there will introduce some redundant codes.
> This patch is to remove this restriction, let others reuse the current
> EM/EMe definition.

I think the other way (adding new definitions for the cases when the
name and string are different) is less error prone.

> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
[]
> +#define UFS_LINK_STATES						\
> +	EM(UIC_LINK_OFF_STATE, "UIC_LINK_OFF_STATE")		\
> +	EM(UIC_LINK_ACTIVE_STATE, "UIC_LINK_ACTIVE_STATE,")	\

For instance:

Like here where you added an unnecessary and unwanted comma


