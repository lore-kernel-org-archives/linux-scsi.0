From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 22:38:49 +0900
Message-ID: <20081022223901S.fujita.tomonori@lab.ntt.co.jp>
References: <20081022213418B.fujita.tomonori@lab.ntt.co.jp>
	<4B6A08C587958942AA3002690DD4F8C32D2C5E17@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60545 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYJVNkP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 09:40:15 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C32D2C5E17@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bo.Yang@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, pterjan@gmail.com, matthew@wil.cx, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Sumant.Patro@lsi.com, bugme-daemon@bugzilla.kernel.org, Winston.Austria@lsi.com

On Wed, 22 Oct 2008 07:03:03 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> I saw the latest working kernel: 2.6.24 and first failing kernel
> version: 2.6.27-rc8.  I understand there are lots of changes between
> those two kernels.  Can you take a look the changes from kernels to
> find out the root cause?

Sorry, I didn't explain the possible root cause.

struct scsi_cmnd in 2.6.25:

unsigned char cmnd[MAX_COMMAND_SIZE];


struct scsi_cmnd in 2.6.26:

unsigned char *cmnd;


In short, struct scsi_cmnd doesn't have static array for cdb. You need
to allocate memory for it (the scsi midlayer does for common usage).

So

static int
mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
{
...
	scb = &adapter->int_scb;
	memset(scb, 0, sizeof(scb_t));

	scmd = &adapter->int_scmd;
	memset(scmd, 0, sizeof(Scsi_Cmnd));

	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
	scmd->device = sdev;

	scmd->device->host = adapter->host;
	scmd->host_scribble = (void *)scb;
	scmd->cmnd[0] = MEGA_INTERNAL_CMD;

I suspect that the driver crashes here. My patch adds array to
adapter_t and use it here.

After 2.6.25, sense_buffer also is converted from static array to
pointer. In general, using scsi_allocate_command/scsi_free_command is
the recommended way to use struct scsi_cmnd.

So my latest patch removes struct scsi_cmnd in adapter_t and uses the
API in mega_internal_command().


> Also if you believe this is the driver issue and need LSI to help,
> can you report this issue to LSI?

Yeah, I think that we need to update this driver because of the
changes to SCSI mid-layer.

It would be appreciated if you can test my latest path:

http://marc.info/?l=linux-scsi&m=122467887502481&w=2


Can you think of this thread as a bug report to LSI?
