From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Sat, 15 Nov 2014 08:31:00 -0700
Message-ID: <546771B4.1010507@kernel.dk>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org> <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee> <54665B30.4070708@kernel.dk> <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee> <54669063.6050307@kernel.dk> <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 2014-11-14 23:48, Meelis Roos wrote:
> [  247.424529] sd 0:0:2:0: [sdc] READ CAPACITY failed
> [  247.479803] sd 0:0:2:0: [sdc]
> [  247.517288] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [  247.583978] sd 0:0:2:0: [sdc]
> [  247.621487] Sense Key : Not Ready [current]
> [  247.672493] sd 0:0:2:0: [sdc]
> [  247.710046] Add. Sense: Logical unit not ready, cause not reportable
> [  247.788409] sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
> [  247.861176] sd 0:0:2:0: [sdc] Asking for cache data failed
> [  247.926063] sd 0:0:2:0: [sdc] Assuming drive cache: write through
> [  248.001337] blk-mq: cpu 14 got queue 1828716544
> [  248.053686]   cpu10 -> queue index 809119744
> [  248.104595]   cpu11 -> queue index 0
> [  248.147313]   cpu14 -> queue index 1828716544
> [  248.199394]   cpu15 -> queue index 0
> [  248.244954] sd 0:0:2:0: [sdc] Spinning up disk...

So the issue definitely seems to be related to the fact that this disk 
misbehaves. The hw queue values aren't random either, in fact they CPU14 
mapping is identical to your previous boot, which is0x6d000000. And 
CPU10's mapping is 0x303a3000.

My next move would be to add more debug to the CPU map setup and 
teardown, so that we can verify that the map that is being used above 
has indeed been setup. Unless Christoph has any ideas on what is going 
on here?

-- 
Jens Axboe

