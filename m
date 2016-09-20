From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 0/9] Replay Protected Memory Block (RPMB) subsystem
Date: Tue, 20 Sep 2016 13:11:53 +0200
Message-ID: <20160920111153.GA17297@kroah.com>
References: <1473772984-17562-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542EB180@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542EB180@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Avri Altman <avri.altman@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2016 at 12:17:48PM +0000, Winkler, Tomas wrote:
> \
> > Subject: [PATCH v6 0/9] Replay Protected Memory Block (RPMB) subsystem
> > 
> > 
> > Few storage technologies such is EMMC, UFS, and NVMe support RPMB
> > hardware partition with common protocol and frame layout.
> > The RPMB partition cannot be accessed via standard block layer, but by a set
> > of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
> > PROGRAM_KEY.
> > Such a partition provides authenticated and replay protected access, hence
> > suitable as a secure storage.
> > 
> > The RPMB layer aims to provide in-kernel API for Trusted Execution
> > Environment (TEE) devices that are capable to securely compute block frame
> > signature. In case a TEE device wish to store a replay protected data, it
> > creates an RPMB frame with requested data and computes HMAC of the
> > frame, then it requests the storage device via RPMB layer to store the data.
> > 
> > The layer provides two APIs, for rpmb_req_cmd() for issuing one of RPMB
> > specific commands and rpmb_seq_cmd() for issuing of raw RPMB protocol
> > frames,  which is close to the functionality provided by emmc multi ioctl
> > interface.
> > 
> > A TEE driver can claim the RPMB interface, for example, via
> > class_interface_register ().
> > 
> > A storage device registers its RPMB hardware (eMMC) partition or RPMB W-
> > LUN (UFS) with the RPMB layer providing an implementation for
> > rpmb_seq_cmd() handler. The interface enables sending sequence of RPMB
> > standard frames.
> > 
> > A parallel user space API is provided via /dev/rpmbX character device with
> > two IOCTL commands.
> > Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is performed
> > by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD
> > where the whole RPMB sequence, including RESULT_READ is supplied by the
> > caller.
> > The latter is intended for easier adjusting of the applications that use
> > MMC_IOC_MULTI_CMD ioctl, such as
> > https://android.googlesource.com/trusty/app/storage/
> > 
> > There is a also sample tool under tools/rpmb/ directory that exercises these
> > interfaces and a simulation device that implements the device part.
> > 
> > The code is also available from:
> > 
> > https://github.com/tomasbw/linux-mei.git rpmb
> > 
> 
> Greg, can you please check if this series has addressed all your comments. 
> Are there are any more items that preventing it from merging?

Ugh, my queue is huge right now, give me a week or so to dig out of it
and review this...

Oh wait, you have almost no reviews from anyone else!  Why is it up to
me to do all of this work?  :)

Please get acks from others, at the very least, get it reviewed by other
Intel kernel developers that we know and trust.  I'm amazed you haven't
already done that!

thanks,

greg k-h
