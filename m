Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C66C47254
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC2321775
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588266253;
	bh=p3PY8v4K9MXDL2QVIbKch9hnHXPDV5bO+Bl4Z5ompNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=16L1JTg8LJRd5DGsxADxJ4+biB6JaJjHqP0GHcgadKTl02GPo72aDUjz3SZWW4LqM
	 67uIYeVhkPtQQgmekopk2uhc+mcIJkZBckyUSjtzOroC/gDaJkDl2hxwP7dRj1MoQN
	 YIiMaiLlr2OoYXZQme6564401JV4Zte2Jgw6gGX8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgD3REM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgD3REL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 13:04:11 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FDC20787;
        Thu, 30 Apr 2020 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588266251;
        bh=p3PY8v4K9MXDL2QVIbKch9hnHXPDV5bO+Bl4Z5ompNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofvd7GuJV37V4vJOvUKnWq4C/v1xbd3mvDBxUw04u6XfgRrJHLihJ0khXJpzsYWJi
         42MtVUtsO8njIXQJ+P2HBeIv9z+8wKQu4dFy5SmhhU7L7TKGpapze5VAxJq/l2mj2u
         wzpYGjYJmtlYiphZ0ZzWlzBBFWVL9FLJT4lb9OkY=
Date:   Thu, 30 Apr 2020 10:04:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v12 10/12] fscrypt: add inline encryption support
Message-ID: <20200430170408.GB1003@sol.localdomain>
References: <20200430115959.238073-1-satyat@google.com>
 <20200430115959.238073-11-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430115959.238073-11-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 11:59:57AM +0000, Satya Tangirala wrote:
> +bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
> +{
> +	return inode->i_crypt_info->ci_inlinecrypt;
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_inode_uses_inline_crypto);

Right, this still needs to be exported (I missed that in the diff I suggested).
But the export needs to be fixed to use the double-underscore name.

- Eric
