From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace
 barrier with sequenced flush
Date: Fri, 27 Aug 2010 18:47:42 +0900
Message-ID: <4C7789BE.1060609@ct.jp.nec.com>
References: <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de>
	<4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de>
	<4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org>
	<20100823141733.GA21158@redhat.com>
	<4C739DE9.5070803@ct.jp.nec.com> <4C73FA8F.5080800@kernel.org>
	<4C74CD95.1000208@ct.jp.nec.com> <20100825152831.GA8509@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100825152831.GA8509@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: jack@suse.cz, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, Tejun Heo <tj@kernel.org>, tytso@mit.edu, rwheeler@redhat.com, vst@vlnb.net, swhiteho@redhat.com, chris.mason@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

On 08/26/2010 12:28 AM +0900, Mike Snitzer wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>> Anyway, as you said, the flush error handling of dm-mpath is already
>> broken if data loss really happens on any storage used by dm-mpath.
>> Although it's a serious issue and quick fix is required, I think
>> you may leave the old behavior in your patch-set, since it's
>> a separate issue.
> 
> I'm not seeing where anything is broken with current mpath.  If a
> multipathed LUN is WCE=1 then it should be fair to assume the cache is
> mirrored or shared across ports.  Therefore retrying the SYNCHRONIZE
> CACHE is needed.
> 
> Do we still have fear that SYNCHRONIZE CACHE can silently drop data?
> Seems unlikely especially given what Tejun shared from SBC.

Do we have any proof to wipe that fear?

If retrying on flush failure is safe on all storages used with multipath
(e.g. SCSI, CCISS, DASD, etc), then current dm-mpath should be fine in
the real world.
But I'm afraid if there is a storage where something like below can happen:
    - a flush command is returned as error to mpath because a part of
      cache has physically broken at the time or so, then that part of
      data loses and the size of the cache is shrunk by the storage.
    - mpath retries the flush command using other path.
    - the flush command is returned as success to mpath.
    - mpath passes the result, success, to upper layer, but some of
      the data already lost.

Thanks,
Kiyoshi Ueda
