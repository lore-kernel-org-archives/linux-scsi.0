From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Sun, 3 Apr 2016 19:27:23 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B541DDE71@hasmsx108.ger.corp.intel.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
 <57011A3F.1010007@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <57011A3F.1010007@kernel.org>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 04/03/2016 02:42 AM, Tomas Winkler wrote:
> Few storage technology such is EMMC, UFS, and NVMe support RPMB 
> hardware partition with common protocol and frame layout.
> The RPMB partition cannot be accessed via standard block layer, but by 
> a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and 
> PROGRAM_KEY.
> Such a partition provides authenticated and replay protected access, 
> hence suitable as a secure storage.
>
> A storage device registers its RPMB hardware (emmc) partition or RPMB 
> W-LUN (ufs) with the RPMB layer providing an implementation for
> send_rpmb_req() handler.
> Tere is as well simulation platform device. This is handy as an RPMB 
> key can be programmed only once at storage device lifetime.
>
> The RPMB layer aims to provide in-kernel API for Trusted Execution 
> Environment (TEE) devices that are capable to securely compute block 
> frame signature. A TEE driver can claim rpmb interface, for example, 
> via  class_interface_register ().

What's the workflow?  Does the TEE ask the kernel to do RPMB operations for it and supply the kernel with the authenticated request blobs to forward to the RPMB?

Exactly, though it's not exactly a blob, just the data part,  but it has to have the whole frame in orther to copute the signature correctly.   Neither emmc nor ufs  have dual head so a TEE device cannot access the RPMB partition directly and the access has to done via kernel storage device.

Thanks
Tomas 
