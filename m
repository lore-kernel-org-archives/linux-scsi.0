Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C58C33CB2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E00324672
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579014337;
	bh=ydeBuosiltPcfsDEdZvc5kVp7iD71bPEmNOTm05qYEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=I0HLb9lu7se3JzGoA8HDJ6D4FXT+CZC+GvLc6Sl+a/rSzIpffGA0hD11Xw0TsXM05
	 /125ete2w/t/uK2th69CV3M9y3x6RGmK1rCRISV/79VjgdWgI1MZtXHnuqU4XRsz2O
	 FefwPSQhhjCTM6/jvkNKBbN3JYLxCmLGZnx5qTBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgANPFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 10:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbgANPFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 10:05:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 537E3222C4;
        Tue, 14 Jan 2020 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579014332;
        bh=ydeBuosiltPcfsDEdZvc5kVp7iD71bPEmNOTm05qYEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HkmdOP22cGskIQMD2YCPEllQ3MCdzu/35gtVL61fkqXuQE8lsI4X0vA0APRGqN9ET
         ATbjZ+sON3udGwGI5lSEAqy3ZwHExS0sK9NJ6FF2rvFBNWPv5hj0MP1Y9qrE7UR75Q
         WQLntYYqzHvl3hnUNtLzfRT0pYjZDpIMPXD9Qrtw=
Date:   Tue, 14 Jan 2020 16:05:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     rafael@kernel.org, lduncan@suse.com, cleech@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH 1/3] drivers: base: Support atomic version of
 attribute_container_device_trigger
Message-ID: <20200114150530.GA1975425@kroah.com>
References: <20200106185817.640331-1-krisman@collabora.com>
 <20200106185817.640331-2-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106185817.640331-2-krisman@collabora.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 06, 2020 at 01:58:15PM -0500, Gabriel Krisman Bertazi wrote:
> attribute_container_device_trigger invokes callbacks that may fail for
> one or more classdev's, for instance, the transport_add_class_device
> callback, called during transport creation, does memory allocation.
> This information, though, is not propagated to upper layers, and any
> driver using the attribute_container_device_trigger API will not know
> whether any, some, or all callbacks succeeded.
> 
> This patch implements a safe version of this dispatcher, to either
> succeed all the callbacks or revert to the original state.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
