From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace
 barrier with sequenced flush
Date: Wed, 25 Aug 2010 00:14:21 +0100
Message-ID: <20100825001421.67eb8aad@lxorguk.ukuu.org.uk>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
	<20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org>
	<20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org>
	<20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org>
	<20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org>
	<20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com>
	<4C72660A.7070009@kernel.org> <4C73FD52.7000305@vlnb.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C73FD52.7000305@vlnb.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, tytso@mit.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, Tejun Heo <tj@kernel.org>, jack@suse.cz, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com
List-Id: linux-scsi@vger.kernel.org

> In SCSI there are conditions when a command, including FLUSH 
> (SYNC_CACHE), failed which don't imply lost data. For them the caller 
> expected to retry the failed command. Most common cases are Unit 
> Attentions and TASK QUEUE FULL status.

ATA expects the command to be retried as well because a failed flush
indicates the specific sector is lost (unless the host still has a copy
of course - which is *very* likely although we don't use it) but the rest
of the flush transaction can be retried to continue to flush sectors
beyond the failed one.

Alan
