From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.2.7
Date: Mon, 26 Jul 2004 12:16:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090836994.4104da027ea5a@imp6-q.free.fr>
References: <1090836168.4104d6c8a2b22@imp6-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-2.free.fr ([213.228.0.169]:36059 "EHLO
	postfix3-2.free.fr") by vger.kernel.org with ESMTP id S265106AbUGZKQg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 06:16:36 -0400
In-Reply-To: <1090836168.4104d6c8a2b22@imp6-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, Jan Kunigk <jan.kunigk@de.ibm.com>, linux-scsi@vger.kernel.org

Selon christophe.varoqui@free.fr:

> Hello,
>
> here goes multipath-tools version 0.2.7
>
> Jan,
> the ULUA framework I got implemented is rather simple :
> 1) the path struct gets a new ->priority member
> 2) before path grouping, sort the path list by priority
>
> The missing link is the priority fetcher.
> Does that framework fit your needs ?
>
Note, that I see this ->priority as a generic way to deport path grouping policy
into callout binaries : I'll code a generic "group_by_prio" pgpolicy and a
priority_callout config keyword for that.


> 2004-07-24 multipath-tools-0.2.7
>         * [multipath] args parser moved to getopt
>           <genanr@emsphone.com>
>         * [multipath] zero conf->hotplugdev at allocation
>           <genanr@emsphone.com>
>         * [multipath] clean up failed devmap creation attempt
>         * [libs] update to libdevmapper 1.00.19
>         * [multipath] framework for claimed device skipping
>           still lacks a reliable way to know if the device is
>           claimed and by who (fs, swap, md, dm, ...). If you
>           think it is valid to let libdevmapper hit the wall,
>           please speak up and tell so.
>         * [multipath] shut down stderr when calling into libdm
>         * [multipath] reformat the verbose output
>         * [multipath] framework for path priority handling (ULUA)
>         * [multipath] kill all reference to group_by_tur
>         * [multipath] integrate path state logic into multibus &
>           failover pgpolicies. This obsoletes the group_by_tur one
>           which is now the same as multibus.
>         * [multipath] zalloc mp structs to avoid garbage in ->size
>         * bump version requisite for scsi_id to 0.6 to support the new
>           '-u' flag (s/ /_/ for proper JBOD device map naming)
>         * [multipath] correct the for(;;) limits to accept 1-slot
>           pathvecs
>         * [multipath] push WWID_SIZE to 64 char (scsi_id w/ JBODs)
>         * [multipath] add a exit_tool() wrapper fn for runfile unlink
>         * [multipath] add a "default_path_grouping_policy" keyword in the
>         * "defaults" block.
>         * [multipath] add a "default_getuid_callout" keyword in the
>           "defaults" block. Now multipath is going to work with JBODs
>         * [multipath] fix segfault when pathvec is empty after
>           get_pathvec()
>         * move to template based specfile to avoid regular version skew
>
> Downloads and docs at http://christophe.varoqui.free.fr
>
> regards,
> cvaroqui
> --
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


--
