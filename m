From: Mark Rustad <mrustad@mac.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Thu, 4 Nov 2004 12:56:01 -0600
Message-ID: <2BF4BB83-2E93-11D9-804F-0003934F6348@mac.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de> <4177C13C.10007@steeleye.com> <20041021140236.GO10531@suse.de> <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com> <91146D2E-2918-11D9-B6DC-0003934F6348@aol.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91146D2E-2918-11D9-B6DC-0003934F6348@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I came up with a patch that seems to fix the kernel crashing on a RAID1 
device failure problem. I do not have confidence that it really is the 
correct fix, but I'm pretty sure that it is touching the right area. 
I'm sure someone more familiar with this area of the kernel will 
recognize from this what the correct fix is, if this is not it. 
Submitted for your consideration:

--- a/drivers/block/ll_rw_blk.c 2004-11-01 14:28:48.000000000 -0600
+++ b/drivers/block/ll_rw_blk.c 2004-11-01 14:29:13.000000000 -0600
@@ -2865,10 +2865,7 @@
       * if the request wasn't completed, update state
       */
      if (bio_nbytes) {
          bio_endio(bio, bio_nbytes, error);
-       bio->bi_idx += next_idx;
-       bio_iovec(bio)->bv_offset += nr_bytes;
-       bio_iovec(bio)->bv_len -= nr_bytes;
      }

      blk_recalc_rq_sectors(req, total_bytes >> 9);

With this applied, my kernel does not crash on media errors on one of 
the devices and just keeps on running on the other device. In my case, 
the code just above these lines was taking the path that was walking 
through the bio_iovec array.

-- 
Mark Rustad, MRustad@mac.com

