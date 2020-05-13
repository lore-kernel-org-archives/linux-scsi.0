Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8F3C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 16:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30E420671
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589388431;
	bh=/v2IdDrymQyOQwGKwD3DYskW13FfX9JBpATBQnCGEcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IzttIH8Dg6U53kZo+0Y050OTG/swYSM2FD6cZvD34LxtApdOzPVwxpur840oeloiV
	 QUzMji8AsbqrbZigjgBCHZMlrpgxgsFoUki80JMrifpJEajLkPbHQItk8y4fVXVCz5
	 4js6tMkMXvZoyofwT0jFVF0+pw+GBCegpycXHCTk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732671AbgEMQrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 12:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbgEMQrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 12:47:10 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACEC32054F;
        Wed, 13 May 2020 16:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589388430;
        bh=/v2IdDrymQyOQwGKwD3DYskW13FfX9JBpATBQnCGEcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nAeGjCGQQCEXECiiVUZ7LQP3/1bJtcWmeYZLTYbvUSHQs9C+sg1PGBkyCDUte1c9B
         UYBEHmYQLrO4Ycv+IwUgQAYx+Ig+4XaEH8IHLafNSLlVrXNOtJ6gnpBTOZ0UREEf2n
         x/hhC5VoAEYTb5c9q+su5I0gJUEo4ndlnhA7bCQY=
Date:   Wed, 13 May 2020 09:47:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v12 01/12] Documentation: Document the blk-crypto
 framework
Message-ID: <20200513164707.GA1243@sol.localdomain>
References: <20200430115959.238073-1-satyat@google.com>
 <20200430115959.238073-2-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430115959.238073-2-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 11:59:48AM +0000, Satya Tangirala wrote:
> The blk-crypto framework adds support for inline encryption. There
> are numerous changes throughout the storage stack. This patch documents
> the main design choices in the block layer, the API presented to users
> of the block layer (like fscrypt or layered devices) and the API presented
> to drivers for adding support for inline encryption.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Looks good, you can add:

    Reviewed-by: Eric Biggers <ebiggers@google.com>

But a few comments for when you resend:

> +When a bio is added to a request, the request takes over ownership of the
> +``bi_crypt_context`` of the bio - in particular, the request keeps the
> +``bi_crypt_context`` of the first bio in its bio-list, and frees the rest
> +(blk-mq needs to be careful to maintain this invariant during bio and request
> +merges).

Is this part up-to-date?  There was discussion about not freeing the bios' crypt
contexts.

> +``blk_crypto_evict_key`` should be called by upper layers when they want
> +to ensure that a key is removed from memory and from any keyslots in inline
> +encryption hardware that the key might have been programmed into (or the
> +blk-crypto-fallback).

This should be reworded to emphasize that blk_crypto_evict_key()
*must* be called (as now the keyslot manager has a pointer to the key).

> +API presented to device drivers
> +===============================
> +
> +A :c:type:``struct keyslot_manager`` should be set up by device drivers in the

"keyslot_manager" => "blk_keyslot_manager".  Likewise below.

> +``request_queue`` of the device. The device driver needs to call
> +``blk_ksm_init`` on the ``keyslot_manager``, which specfying the number of
> +keyslots supported by the hardware.

"which specfying" => "while specifying"

> +The device driver also needs to tell the KSM how to actually manipulate the
> +IE hardware in the device to do things like programming the crypto key into
> +the IE hardware into a particular keyslot. All this is achieved through the
> +:c:type:`struct keyslot_mgmt_ll_ops` field in the KSM that the device driver
> +must fill up after initing the ``keyslot_manager``.

"keyslot_mgmt_ll_ops" => "blk_ksm_ll_ops"

- Eric
