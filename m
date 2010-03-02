From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: mvsas panic
Date: Tue, 2 Mar 2010 01:31:48 -0500
Message-ID: <87d699441003012231q251044acl17f59b61ca09c9d@mail.gmail.com>
References: <87d699441002281928u7e57f4a1saacddd020a6d6c3f@mail.gmail.com>
	 <6B62480106F2B34D8404CF2FDAA4D9EF71F64F68AF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F64F68AF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-kernel-owner@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 1, 2010 at 11:24 PM, Srinivas Naga Venkatasatya
Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
> Hi,
>
> Did you tried with latest mvsas patch submitted by me? If not try with attached patch and let me know if you have any issues.
> Note: Apply this patch on 2.6.32 kernels.

Thanks for the suggestion. Graham Reed also suggested I try your
patch. I glanced at the patch -- it seems fairly similar to patch 6/7
from Andy Yan from Nov 2009, although with some differences. I will
try both your patch and also Andy Yan's patch series (separately) and
see how it goes.


>
> --Srini.
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ilia Mirkin
> Sent: Monday, March 01, 2010 8:58 AM
> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: mvsas panic
>
> Hi,
>
> I had earlier e-mailed about an apparent NCQ vs non-NCQ command issue
> on this machine in mvsas/libsas that didn't get any attention
> (http://kerneltrap.org/mailarchive/linux-scsi/2010/1/24/6725113), but
> now I've run into a crash/panic issue as well... perhaps related which
> is why I mention it.
>
> Unfortunately I don't have a full backtrace, but I'm going to try to
> reproduce it tonight with netconsole set up.
>
> Attached is a screenshot of the crash; the visible part of the trace
> goes something like
>
> mvs_interrupt
> mvs_64xx_isr
> mvs_int_full
> mvs_int_rx
> scsi_io_completion
> mvs_slot_compete
> sas_ata_task_done
> ata_qc_complete
> __ata_qc_complete
> ata_sg_clean
> swiotlb_unmap_sg_attrs
> ... and then it cuts off.
>
> After this the machine was completely unresponsive, didn't even ping.
> Please let me know if you have any ideas for figuring out what's wrong
> here, if there's something I should test, etc. I noticed that there
> were a bunch of patches a few months ago for mvsas, but they were
> never merged... should I try those? I checked the commits that went
> into 2.6.33, that didn't seem to have any relevant changes to mvsas,
> libsas, or libata core features, but I can try that too if you think
> it's likely to help things out.
>
> The workload that triggered this was just dd reading and writing
> (simultaneously) to 11 of the disks (/dev/zero -> disk, disk ->
> /dev/null, bs=1M).
>
> Some information about the machine:
>
> Supermicro X8DTE, 2x L5520 cpu, 24G ram (12G per cpu). Areca 1300ix-16
> controller, with 12 drives attached.
>
> Various virtualization features enabled in bios, like VT-d, SR-IOV,
> etc (none of which I'm using, but wanted to play with at some point).
> Boot log below.
>
... logs trimmed ...
