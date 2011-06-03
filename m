From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Fri, 3 Jun 2011 00:10:57 -0700
Message-ID: <BANLkTinKGxN1TAfpK1gJ=Yc2wsVrtB250w@mail.gmail.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
	<9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
	<F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
	<4DE87A83.4090801@intel.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62771 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1FCHNB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 03:13:01 -0400
Received: by wwa36 with SMTP id 36so1372003wwa.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2011 00:13:00 -0700 (PDT)
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Jun 2, 2011 at 11:45 PM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
>
>
>>Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
>
>>On 6/2/2011 8:27 PM, Xiangliang Yu wrote:
>>> Hi, all
>>> I upgrade kernel version to 2.6.39 and find out a kernel panic when I test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the driver is OK in version 2.6.37
>
>>If it is a stable reproduction can you bisect it?
> What I use is latest kernel version (2.6.39).

Right, if the driver consistently fails in 2.6.39 and runs fine in
2.6.37 then you can use git bisect [1] to possibly find the commit
that broke things.

git bisect start
git bisect bad v2.6.39
git bisect good v2.6.37
<run test>
git bisect good/bad depending on test results.

Although you might try 2.6.38 first to cut down on the number of
kernels you need to test.

--
Dan

[1]: http://www.kernel.org/pub/software/scm/git/docs/git-bisect-lk2009.html
