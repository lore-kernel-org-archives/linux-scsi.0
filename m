From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Thu, 18 Nov 2010 12:25:50 +0200
Message-ID: <4CE4FF2E.1010303@panasas.com>
References: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org> <20101117222752.GA26760@infradead.org> <1290032970.31890.61.camel@haakon2.linux-iscsi.org> <20101117223735.GA514@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:38877 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0KRKZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 05:25:54 -0500
In-Reply-To: <20101117223735.GA514@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On 11/18/2010 12:37 AM, Christoph Hellwig wrote:
> On Wed, Nov 17, 2010 at 02:29:30PM -0800, Nicholas A. Bellinger wrote:
>> Hmmm, this is following jgarzik's recommendation for LLDs that we could
>> not immediately identify a internal spin_lock to disable interrupts
>> upon.  (eg: not libiscsi and libata).
> 
> In that case wait for the driver author to identify it.  If there's
> no maintainer in reach chance is the driver doesn't care about the push
> down.  No need to rush any of this, do it one driver at a time and get
> it right.

I totally agree with Christoph. Patches 5, 6, 8, 11 all change behaviour

I would like to see an "I audit the driver and ..." Please see my comment
to [patch 6]

Do it one by one and open-code the local_irq_save/restore inside the
main function. It's not like you can get away from a total audit and
testing.

Boaz
