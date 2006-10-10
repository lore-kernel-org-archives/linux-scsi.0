From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 34/36] Maintain module-parameter name consistency with qla2xxx/qla4xxx.
Date: Tue, 10 Oct 2006 14:58:30 -0700
Message-ID: <20061010215830.GJ8597@andrew-vasquezs-computer.local>
References: <200610102141.k9ALfucA025474@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:59166 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1030562AbWJJV6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:58:32 -0400
Content-Disposition: inline
In-Reply-To: <200610102141.k9ALfucA025474@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, 10 Oct 2006, akpm@osdl.org wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> -ENOCHANGELOG.
> 
> Don't know who wrote it.

it was a simple "perl -pi -e '" thingy...

> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>


Fredrick posted the following patch to address a variable name
conflict in the recently added qla4xxx driver:

http://article.gmane.org/gmane.linux.kernel/453703

I'd suggested that the prefix be ql2x/ql4x rather than qla2_/qla4_ for
consistency (some at least):

http://article.gmane.org/gmane.linux.kernel/453769


Linus ended up adding Fredrick's patch to the linux-2.6 tree.  I then
ended up rediffing and posting the updated patch (you've now added to
mm):

http://article.gmane.org/gmane.linux.kernel/454031


Sorry for the confusion -- how's this (too verbose):

---
Maintain module-parameter name consistency with qla2xxx/qla4xxx.

The recently added the iSCSI qla4xxx driver contains a global
(non-static) variable that clashes with a pre-existing variable
present in qla2xxx.

Commit d7a297baa6edea94167163bed808c6a8933bd5aa added a 'qla2_'
and 'qla4_' prefix to the offending variable name.  Replace the
'qla2_/qla4_' prefixes with 'ql2x/ql4x' to maintain consistency
with other module-parameters.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
