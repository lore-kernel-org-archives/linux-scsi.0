From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 22:49:12 +0200
Message-ID: <4FA19DC8.2030001@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502135123.GF16976@quack.suse.cz> <4FA13DDF.9010006@redhat.com> <20120502161038.01ee9b59@pyramind.ukuu.org.uk> <4FA157A6.7050209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA157A6.7050209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 02/05/2012 17:49, Paolo Bonzini ha scritto:
>> > Customisable filters are not hard. We've got all the filtering code in
>> > kernel and the ability to verify filters, even the ability to JIT them.
>> > Just support adding/removing/running a BPF filter on the channel in
>> > question.
>> > 
>> > So it shouldn't be much code to do what you want.
> Yes, it's not much code if I don't get into cgroups land and stick with
> a ioctl to add and remove BPF filters that look at CDBs.

Except that then I need to access some "struct file" member in SG_IO,
thus changing ioctl from block_device/fmode to block_device/file.  This
would partially undo the 2007 switch from inode/file by Al Viro.
Somehow I'm not that optimist anymore, though I'd be happy to be proven
wrong.

Paolo
