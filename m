From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Tue, 21 Dec 2004 14:02:12 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE074BF47E@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The devinfo.c file in the multipath-tools-0.4.1 appears to have a typo
in the code to get the node_name attr in the fc_transport sysfs entry.
Path below should fix it. BTW why does a failure to get a node_name
attribute, result in failure of multipath discovery (because devinfo
returns failure)even if the "group_by_node_name" policy is not used ?
Can't we just NULL out the tgt_node_name string in the sysfs_devinfo
routine and fail the group_by_node_name routine if that policy was
chosen ? That is what happened in my case. Multipath discovery failed
due to above reason even though node_name grouping was not specified. 

***************

diff new_multipath/devinfo.c old_multipath/devinfo.c
349c349
<
"%s/class/fc_transport/target%i:%i:%i/node_name",
---
> 			"%s/class/fc_transport/%i:%i:%i:%i/node_name",
353c353,354
< 			curpath->sg_id.scsi_id)) {
---
> 			curpath->sg_id.scsi_id,
> 			curpath->sg_id.lun)) {

***********

Ramesh.    

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of christophe varoqui
Sent: Monday, December 20, 2004 8:01 AM
To: device-mapper development
Cc: linux-raid@vger.kernel.org;
linux-hotplug-devel@lists.sourceforge.net; linux-scsi@vger.kernel.org
Subject: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1

Hello,

here goes multipath-tools-0.4.1

Another round of bugfixes.
People are starting to report sane behaviour.

If someone at IBM (or knowledgeable enough) is listening, we need a
method to check a path status on a T200 that don't trigger a controler
bounce. Is it possible at all ?

Full ChangeLog for the release :

        * [multipath] bump SERIAL_SIZE to 19
        * [multipath] add a new group_by_node_name pgpolicy
        * [multipath] move getopt policy parser to
          get_policy_id()
        * [multipath] remove get_evpd_wwid()
        * [checkers] fix the wwn_set test in emc checker
          (Hergen Lange)
        * [checkers] treat the emc checker in the name to
          index translator function (Hergen Lange)
        * [multipath] print to stderr DM unmet requirement
          (Guido Guenther)
        * [multipath] fix realloc return value store not
          propagated to caller by merge_word() (Nicola Ranaldo)

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
