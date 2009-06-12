From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13519] Syntax error. Not enough parameters for macro
 'qla_printk'.
Date: Fri, 12 Jun 2009 12:32:32 GMT
Message-ID: <200906121232.n5CCWW3B031211@demeter.kernel.org>
References: <bug-13519-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33189 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZFLMc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:32:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5CCWW0Y031212
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 12:32:32 GMT
In-Reply-To: <bug-13519-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13519





--- Comment #1 from Matthew Wilcox <matthew@wil.cx>  2009-06-12 12:32:31 ---
On Fri, Jun 12, 2009 at 12:25:13PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
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
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
