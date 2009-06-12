From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 13519] New: Syntax error. Not enough parameters for macro
	'qla_printk'.
Date: Fri, 12 Jun 2009 06:32:29 -0600
Message-ID: <20090612123228.GD19977@parisc-linux.org>
References: <bug-13519-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50352 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbZFLMc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:32:27 -0400
Content-Disposition: inline
In-Reply-To: <bug-13519-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2009 at 12:25:13PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> i have detected a wrong macro call in file qla_sup.c. To detect this issue i
> used the static code analysis tool cppcheck. It prints the following output:
> 
> [linux-2.6.30/drivers/scsi/qla2xxx/qla_sup.c:352]: (error) Syntax error. Not
> enough parameters for macro 'qla_printk'.
> 
> Take a look at file qla_sup.c line 352 
> 
>                 DEBUG9_10(qla_printk(
>                     "NVRAM didn't go ready...\n"));
> 
> 
> The maro definition is in file qla_def.h (2657):
> 
> #define qla_printk(level, ha, format, arg...) \
>     dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
> 
> As you can see, it needs more than one parameter.

I believe your tool is defective.  As I understand the way variadic
macros work, if there is no 'arg', the ## operator swallows up the
preceeding symbol (ie the ',') and so you'll get:

	dev_printk(level , &((ha)->pdev->dev) , format);

which is perfectly fine.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
