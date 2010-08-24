From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Tue, 24 Aug 2010 21:11:46 +0400
Message-ID: <4C73FD52.7000305@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C72660A.7070009@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Tejun Heo, on 08/23/2010 04:14 PM wrote:
>> I think that's correct and changing the priority of DM_ENDIO_REQUEUE
>> for REQ_FLUSH down to the lowest should be fine.
>> (I didn't know that FLUSH failure implies data loss possibility.)
>
> At least on ATA, FLUSH failure implies that data is already lost, so
> the error can't be ignored or retried.

In SCSI there are conditions when a command, including FLUSH 
(SYNC_CACHE), failed which don't imply lost data. For them the caller 
expected to retry the failed command. Most common cases are Unit 
Attentions and TASK QUEUE FULL status.

Vlad
