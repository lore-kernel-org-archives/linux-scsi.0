From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: StorageWorks multipath support
Date: Wed, 15 Jun 2005 10:56:34 +0200
Message-ID: <20050615085634.GA16446@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here is a note describing the lego blocks needed to have a fully operational multipath stack with StorageWorks and Qlogic hardware.

Kernel :
========

2.6.12-rc6

Additional patches :
====================

Qlogic : LU scaning fix
http://marc.theaimsgroup.com/?l=linux-scsi&m=111836291000433&w=2

Qlogic : Postpone fc_rport block/unblock to scheduled work
http://marc.theaimsgroup.com/?l=linux-scsi&m=111868700022257&w=2

Mike Christie : export block layer function
https://www.redhat.com/archives/dm-devel/2005-June/msg00084.html

Hardware Handler module :
=========================

Mike Christie, Christophe Varoqui : 
http://christophe.varoqui.free.fr/multipath-tools/dm-hp-sw.tar.bz2

Multipath Tools :
=================

git HEAD up to commit fd9857d2eb9796d0a205887bdff879d56355eda2 at minimum :
http://kernel.org/pub/scm/linux/storage/multipath-tools/.git

Configlet :
===========

device {
        vendor                  "COMPAQ"
        product                 "HSV110 (C)COMPAQ"
        path_grouping_policy    group_by_serial
        path_checker            hp_sw
        features                "1 queue_if_no_path"
        hardware_handler        "1 hp_sw"
}


It would be good to have the kernel patches pushed to 2.6.12 before it comes out.

Happy testing,
cvaroqui
