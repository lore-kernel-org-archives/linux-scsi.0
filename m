From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/2] fusion - honour return value of
	pci_enable_device() in mpt_resume()
Date: Fri, 16 Mar 2007 09:27:26 -0500
Message-ID: <1174055246.3519.5.camel@mulgrave.il.steeleye.com>
References: <20070316070521.GB1081@verge.net.au>
	 <20070316070550.GC1081@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55947 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965114AbXCPO1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2007 10:27:40 -0400
In-Reply-To: <20070316070550.GC1081@verge.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Horms <horms@verge.net.au>
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>

On Fri, 2007-03-16 at 16:05 +0900, Horms wrote:
> +       err = pci_enable_device(pdev);
> +       if (err < 0)
> +               return err;

Traditionally, this should be 

if (err)
	return err;

The reason is that <0 is a signed comparison which can be slightly more
expensive on some architectures and it's unnecessary if zero is the only
successful return.

James


