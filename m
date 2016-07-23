From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v5 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Sat, 23 Jul 2016 07:44:48 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542A1CC6@hasmsx108.ger.corp.intel.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Avri Altman <avri.altman@gmail.com>, "Dattatraya Kulkarni, Anisha" <anisha.dattatraya.kulkarni@intel.com>, "jerome.forissier@linaro.org" <jerome.forissier@linaro.org>
List-Id: linux-scsi@vger.kernel.org


> 
> Few storage technologies such is EMMC, UFS, and NVMe support RPMB
> hardware partition with common protocol and frame layout.
> The RPMB partition cannot be accessed via standard block layer, but by a set
> of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
> PROGRAM_KEY.
> Such a partition provides authenticated and replay protected access, hence
> suitable as a secure storage.
> 
> The RPMB layer aims to provide in-kernel API for Trusted Execution
> Environment (TEE) devices that are capable to securely compute block frame
> signature. In case a TEE device wish to store a replay protected data, it
> creates an RPMB frame with requested data and computes HMAC of the
> frame, then it requests the storage device via RPMB layer to store the data.
> A TEE driver can claim the RPMB interface, for example, via
> class_interface_register ().
> The layer provides two APIs, for rpmb_req_cmd() for issuing one of RPMB
> specific commands and rpmb_seq_cmd() for issuing of raw RPMB protocol
> frames,  which is close to emmc multi ioctl interface.
> 
> A storage device registers its RPMB hardware (eMMC) partition or RPMB W-
> LUN (UFS) with the RPMB layer providing an implementation for
> rpmb_seq_cmd() handler. The interface enables sending sequence of RPMB
> standard frames.
> 
> A parallel user space API is provided via /dev/rpmbX character device with
> two IOCTL commands.
> Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is performed
> by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD
> where the whole RPMB sequence, including RESULT_READ is supplied by the
> caller.
> The latter is intended for easier adjusting of the applications that use
> MMC_IOC_MULTI_CMD ioctl, such as
> https://android.googlesource.com/trusty/app/storage/
> 
> There is a also sample tool under tools/rpmb/ directory that exercises these
> interfaces and a simulation device that implements the device part.
> 
> Tomas Winkler (8):
>   rpmb: add Replay Protected Memory Block (RPMB) subsystem
>   char: rpmb: add sysfs-class ABI documentation
>   char: rpmb: add device attributes
>   char: rpmb: provide a user space interface
>   char: rpmb: add RPMB simulation device
>   tools rpmb: add RPBM access tool
>   mmc: block: register RPMB partition with the RPMB subsystem
>   scsi: ufs: connect to RPMB subsystem
>

I've got few off line request for git access of this code, so here si the repo https://github.com/tomasbw/linux-mei.git  branch rpmb.
The branch is rebasing one  over linux master branch 

Thanks and will appreciate any public  review. 
Tomas


 

