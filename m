From: Mike Christie <michaelc@cs.wisc.edu>
Subject: request based multipath
Date: Thu, 10 Aug 2006 05:03:45 -0400
Message-ID: <44DAF671.5000705@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I know I said I would not do it, but I was without internet access for
some time and the request based multipath stuff was the only code on my
computer, so I updated the code and fixed the locking and irq bugs.

I stuck it in the multipath branch of my iscsi tree here
http://kernel.org/git/?p=linux/kernel/git/mnc/linux-2.6-iscsi.git;a=summary
I am not looking for a formal review of the patches so I will not send
the patches to the list unless someone asks. I just updated the code due
to popular request and because I was testing the request struct timer
patch :)

It compiles. It works, but has not been tested very hard. There are lots
of things I did not handle because if we move it to dm then I need to
update some of that code to handle things properly. And there is a nasty
performance problem. I think this is due to me using the block layer
functions as-is in a little less than optimal way. It is about a 1-2%
drop for normal setups like when using qla2xxx or lpfc or iscsi, but
when using libata with very small IOs we hit some problems that I
believe are result of me using the block layer with no modifications to
the queueing, unplugging and locking. I will continue to look into this.

I did not hook this into Jens's cmd type stuff and my patch to move the
scsi hw handlers to the scsi layer. I did not have time. The code does
have us send the sense and request->errors to the multipath layer for
read and writes and failover IOs, and the io scheduler is in the correct
place now. I still have to hook into the dm layer or we have to figure
out what we are going to do about that - maybe just port multipath-tools
to the new multipath layer (this should not be too bad since we can add
a interface similar to dm's very easily).

So Alasdair tell me what you want to do and if you have time? If you are
busy Mike Anderson and I and the NEC guys could probably take this task
and that way we can get multipath development going again.
