From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Fri, 2 Sep 2011 16:13:26 -0700
Message-ID: <20110902161326.42c52c76.akpm@linux-foundation.org>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	<1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20110901160724.GN9189@beardog.cce.hp.com>
	<1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab1IBXOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 19:14:07 -0400
In-Reply-To: <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: scameron@beardog.cce.hp.com, Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, mikem@beardog.cce.hp.com, Alex Deucher <alexander.deucher@amd.com>

On Thu, 01 Sep 2011 19:40:15 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> OK I found the bad commit,I got lucky... I lost some files but my
> machine was able to complete the bisection. CC involved people
> 
> git bisect start
> # bad: [9e79e3e9dd9672b37ac9412e9a926714306551fe] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
> git bisect bad 9e79e3e9dd9672b37ac9412e9a926714306551fe
> # good: [322a8b034003c0d46d39af85bf24fee27b902f48] Linux 3.1-rc1
> git bisect good 322a8b034003c0d46d39af85bf24fee27b902f48
> # bad: [0c3bef612881ee6216a36952ffaabfc35b83545c] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> git bisect bad 0c3bef612881ee6216a36952ffaabfc35b83545c
> # good: [8c70aac04e01a08b7eca204312946206d1c1baac] Merge branch 'staging-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
> git bisect good 8c70aac04e01a08b7eca204312946206d1c1baac
> # good: [291b63c86aea8a571ddf913d41ab5156b8314dad] Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6
> git bisect good 291b63c86aea8a571ddf913d41ab5156b8314dad
> # good: [aa462abe8aaf2198d6aef97da20c874ac694a39f] mm: fix __page_to_pfn for a const struct page argument
> git bisect good aa462abe8aaf2198d6aef97da20c874ac694a39f
> # good: [5c80c71b9a0ec518b4b58d2a61de01a04f4a4453] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
> git bisect good 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453
> # good: [2c4ac99f983f1341b5962a16b5e8de6049bf10b5] Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev
> git bisect good 2c4ac99f983f1341b5962a16b5e8de6049bf10b5
> # bad: [0a2daa1cf35004f5adbf4138555cc5669abf3a3e] PCI: make cardbus-bridge resources optional
> git bisect bad 0a2daa1cf35004f5adbf4138555cc5669abf3a3e
> # bad: [be768912a49b10b68e96fbd8fa3cab0adfbd3091] PCI: honor child buses add_size in hot plug configuration
> git bisect bad be768912a49b10b68e96fbd8fa3cab0adfbd3091
> # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric
> git bisect bad b03e7495a862b028294f59fc87286d6d78ee7fa1
> commit b03e7495a862b028294f59fc87286d6d78ee7fa1
> Author: Jon Mason <mason@myri.com>
> Date:   Wed Jul 20 15:20:54 2011 -0500
> 
>     PCI: Set PCI-E Max Payload Size on fabric

fyi, this patch also broke drivers/gpu/drm/radeon
(https://bugzilla.kernel.org/show_bug.cgi?id=42162).  Alex has a
workaround (https://bugzilla.kernel.org/attachment.cgi?id=71182).
