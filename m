From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 5.1-rc1: mpt init crash in scsi_map_dma, dma_4v_map_sg on sparc64
Date: Tue, 2 Apr 2019 17:40:55 +0800
Message-ID: <CACVXFVPBj3N=tWEaj-yKK-2K_uaMUdYPp7zC4L1eCZG3_eXsvw@mail.gmail.com>
References: <dbed1f7e-cf7b-0e87-841e-e4dd1eb1ed23@linux.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <dbed1f7e-cf7b-0e87-841e-e4dd1eb1ed23-Y27EyoLml9s@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>
Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 19, 2019 at 7:20 PM Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org> wrote:
>
> Tried 5.1-rc1 on a bunch of sparcs, this hits all my sparcs with sun4v and mpt scsi.
>
> [    2.733263] Fusion MPT base driver 3.04.20
> [    2.742995] Copyright (c) 1999-2008 LSI Corporation
> [    2.743052] Fusion MPT SAS Host driver 3.04.20
> [    2.743881] mptbase: ioc0: Initiating bringup
> [    3.737822] ioc0: LSISAS1064 A3: Capabilities={Initiator}
> [   17.566584] scsi host0: ioc0: LSISAS1064 A3, FwRev=010a0000h, Ports=1, MaxQ=511, IRQ=27
> [   17.595897] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c5001799a45d
> [   17.598465] Unable to handle kernel NULL pointer dereference
> [   17.598623] tsk->{mm,active_mm}->context = 0000000000000000
> [   17.598723] tsk->{mm,active_mm}->pgd = ffff800008802000
> [   17.598774]               \|/ ____ \|/
> [   17.598774]               "@'/ .. \`@"
> [   17.598774]               /_| \__/ |_\
> [   17.598774]                  \__U_/
> [   17.598894] swapper/0(1): Oops [#1]
> [   17.598937] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 5.1.0-rc1 #118
> [   17.598994] TSTATE: 0000000080e01601 TPC: 00000000004483a8 TNPC: 00000000004483ac Y: 00000000    Not tainted
> [   17.599086] TPC: <dma_4v_map_sg+0xe8/0x5c0>

You may use gdb to figure out what the NULL pointer points to:

gdb vmlinux
> l *(dma_4v_map_sg+0xe8)


Thanks,
Ming Lei
