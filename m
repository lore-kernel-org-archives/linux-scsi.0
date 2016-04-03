From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Sun, 3 Apr 2016 06:27:27 -0700
Message-ID: <57011A3F.1010007@kernel.org>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58210 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbcDCN1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Apr 2016 09:27:31 -0400
In-Reply-To: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 04/03/2016 02:42 AM, Tomas Winkler wrote:
> Few storage technology such is EMMC, UFS, and NVMe support RPMB
> hardware partition with common protocol and frame layout.
> The RPMB partition cannot be accessed via standard block layer, but
> by a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
> PROGRAM_KEY.
> Such a partition provides authenticated and replay protected access,
> hence suitable as a secure storage.
>
> A storage device registers its RPMB hardware (emmc) partition or
> RPMB W-LUN (ufs) with the RPMB layer providing an implementation for
> send_rpmb_req() handler.
> Tere is as well simulation platform device. This is handy as an RPMB
> key can be programmed only once at storage device lifetime.
>
> The RPMB layer aims to provide in-kernel API for Trusted Execution
> Environment (TEE) devices that are capable to securely compute block
> frame signature. A TEE driver can claim rpmb interface, for example,
> via  class_interface_register ().

What's the workflow?  Does the TEE ask the kernel to do RPMB operations 
for it and supply the kernel with the authenticated request blobs to 
forward to the RPMB?

--Andy
