From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Sample implementation of a scheme to handle missing interrupts
Date: Mon, 28 Jul 2008 05:58:08 -0600
Message-ID: <20080728115807.GD18026@parisc-linux.org>
References: <20080728055622.GB18026@parisc-linux.org> <ac8af0be0807280250n1684d3fco65631623cd8f60b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43121 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYG1L61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 07:58:27 -0400
Content-Disposition: inline
In-Reply-To: <ac8af0be0807280250n1684d3fco65631623cd8f60b0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 28, 2008 at 05:50:23PM +0800, Zhao Forrest wrote:
> I'm new to sym2 driver, but have a generic question: is it safe to
> call an interrupt handler(i.e. sym53c8xx_intr() in this case) in the
> context of process(i.e. SCSI midlayer thread in this case)?

Not in general.  I should have disabled interrupts before calling into
sym53c8xx_intr() (or in my specific case, just called sym_interrupt()).
It very much depends on how the specific driver is written.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
