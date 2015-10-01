From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Thu, 1 Oct 2015 11:40:23 +0000
Message-ID: <20151001114021.GA15125@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
 <20150930151857.GA26594@lst.de>
 <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp>
 <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp>
 <20151001052159.GA14247@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:63340 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbJALlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 07:41:49 -0400
In-Reply-To: <20151001052159.GA14247@lst.de>
Content-Language: ja-JP
Content-ID: <5083F619018A1A48B4AD83ED6BAA9C78@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 10/01/15 14:21, Christoph Hellwig wrote:
> Any chance you could share all your multipath tests in a git repository
> somewhere?  It seems like you're the only one actually having a good
> set of reproducable but minimalistic tests.

Hmm, sorry I don't have a public git repository...

I'm using a pair of KVM guest, one for iSCSI target and the other
for testing.

I could reproduce the crash using this loop, within a few minutes:

   service multipathd start
   while true; do
     multipath -F
     iscsiadm -m node --logout
     iscsiadm -m node --login
   done

It might implicitly depend on udev to do some small amount of I/O
after device uevent though.

/etc/multipath.conf is like this:

blacklist {
      devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|vd)[0-9]*"
}
defaults {
      user_friendly_names no
      find_multipaths yes
      path_grouping_policy    group_by_prio
      path_selector           "queue-length 0"
      path_checker            "tur"
      failback immediate
      prio alua
      retain_attached_hw_handler yes
}

-- 
Jun'ichi Nomura, NEC Corporation
