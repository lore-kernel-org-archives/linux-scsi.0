From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 02:28:26 +0200
Message-ID: <200708120228.26234.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764004AbXHLAbD@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

I've been building some randconfig kernels lately and I've noticed 
this in a few builds : 

drivers/block/cciss.c:2614: warning: right shift count >= width of type
drivers/block/cciss.c:2615: warning: right shift count >= width of type
drivers/block/cciss.c:2616: warning: right shift count >= width of type

The code in question is this : 

static void do_cciss_request(struct request_queue *q)
{
...
        sector_t start_blk;
...
                        c->Request.CDB[2]= (start_blk >> 56) & 0xff;    //MSB
                        c->Request.CDB[3]= (start_blk >> 48) & 0xff;
                        c->Request.CDB[4]= (start_blk >> 40) & 0xff;
...
}


The problem stems from these lines in include/linux/types.h : 
...
#ifdef CONFIG_LBD
typedef u64 sector_t;
#else
typedef unsigned long sector_t;
#endif
...

So on a 32bit arch without CONFIG_LBD, sector_t is going to be 32 bits wide.
Thus it seems gcc is absolutely right in complaining about those 
56, 48 & 40 bit shifts, since they are indeed wider than the type 
in the "!CONFIG_LBD on a 32bit arch" case.


I must admit that I have no idear what the proper way to deal with 
that is, so I'll just report it so hopefully someone else can fix it.

By the way; I'm building current Linus git tree, head at commit 
ac07860264bd2b18834d3fa3be47032115524cea


Kind regards,
  Jesper Juhl
