From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: 2.6.14-rc5-mm1
Date: Tue, 25 Oct 2005 08:12:56 -0700
Message-ID: <1130253176.6831.48.camel@localhost.localdomain>
References: <20051024014838.0dd491bb.akpm@osdl.org>
	 <1130186927.6831.23.camel@localhost.localdomain>
	 <20051024141646.6265c0da.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932172AbVJYPNp@vger.kernel.org>
In-Reply-To: <20051024141646.6265c0da.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-10-24 at 14:16 -0700, Andrew Morton wrote:
..
> 
> qla2x00_probe_one() has called qla2x00_free_device() and
> qla2x00_free_device() has locked up in
> wait_for_completion(&ha->dpc_exited);
> 
> Presumably, ha->dpc_exited is not initialised yet.
> 
> The first `goto probe_failed' in qla2x00_probe_one() will cause
> qla2x00_free_device() to run wait_for_completion() against an uninitialised
> completion struct.  Because ha->dpc_pid will be >= 0.
> 
> This patch might fix the lockup, but if so, qla2x00_iospace_config()
> failed.  Please debug that a bit for us?

Yes. This patch helped. Due to power failures, my disk trays are
powered off. qla2x00_iospace_config() is failing and causing the
panic on -mm kernel. For odd reasons, older -mm kernels & mainline
kernels doesn't panic.

Thanks,
Badari
