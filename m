Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916E1C3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0A224673
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579036965;
	bh=c8PYOB+50Kwdr59J5Dy8+ISZBBmGFo4QI2J2EjwP7yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WP/ZtHshGqi7xeCfdBokpWyk1jCUTeV8QS8CNQ65fI/lA/aX+roTvfP6zMdhIoM+c
	 xeqCfFIw3/xLjUAhVZXBTE1TodQy5ajKO3pAxa8NACRDdfcsCjzQgoTPkqGuPmIBiF
	 0OjSu+4rz+Xc7Q1WeFhE2KuHygUk9CnAsUvU+ImU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgANVWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgANVWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 16:22:44 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB2324656;
        Tue, 14 Jan 2020 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579036964;
        bh=c8PYOB+50Kwdr59J5Dy8+ISZBBmGFo4QI2J2EjwP7yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mtg8mLRqrHyH3Pl/BnJYWcJgbd7KdfoRejq1YKgwV7Weg3gb4Eau76XslsKhiKU3+
         eRVm56RYnH1DdThk/eD2PGOrsRvEsvwngLKIX8CekgrRW4zJ+YQ2+uFmFTLLM62c39
         rLG3pQpAu4zKMuJFpfF9w6GZjwib6hwwGIJ0uK/Q=
Date:   Tue, 14 Jan 2020 13:22:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 3/9] block: blk-crypto for Inline Encryption
Message-ID: <20200114212241.GE41220@gmail.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20191218145136.172774-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218145136.172774-4-satyat@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 06:51:30AM -0800, Satya Tangirala wrote:
> +static inline int blk_crypto_fallback_submit_bio(struct bio **bio_ptr)
> +{
> +	pr_warn_once("blk-crypto crypto API fallback disabled; failing request");
> +	(*bio_ptr)->bi_status = BLK_STS_NOTSUPP;
> +	return -EIO;
> +}

There needs to be a "\n" at the end of this log message.  Also, due to the
pr_fmt() in blk-crypto.c, this prints as:

	blk-crypto: blk-crypto crypto API fallback disabled; failing request

... so the second "blk-crypto" is redundant.

- Eric
