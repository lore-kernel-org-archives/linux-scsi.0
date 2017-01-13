From: Eric Farman <farman@linux.vnet.ibm.com>
Subject: [PATCH v2] virtio_scsi: Reject commands when virtqueue is broken
Date: Fri, 13 Jan 2017 12:48:05 -0500
Message-ID: <1484329686-21553-1-git-send-email-farman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37795 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750713AbdANAUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 19:20:08 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0DHhvXK002866
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 12:48:14 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27xygj2n0g-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 12:48:13 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <farman@linux.vnet.ibm.com>;
        Fri, 13 Jan 2017 10:48:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, famz@redhat.com, Eric Farman <farman@linux.vnet.ibm.com>

While doing some disruptive testing with QEMU/KVM, I have encountered some
guest problems during hot unplug of virtio-scsi devices depending on the
order of operations in which they are performed.  The following notes
describe my setup (s390x), and how I'm able to reproduce the error and
test the attached fix.

In both the "working" and "failing" case, the detaches appear to work
just fine.  Any sign of problems only begin to appear later based on
other actions I may perform, such as powering off the guest system.

Host:
 # lsscsi -g | grep sg6
 [6:0:6:1074151456]disk    IBM      2107900          .217  /dev/sdg   /dev/sg6 

QEMU:
 - Include the following parameters
    -device virtio-scsi-ccw,id=scsi0
    -drive file=/dev/sg6,if=none,id=drive0,format=raw
    -device scsi-generic,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive0,id=hostdev6
 - QMP commands (working)
    - device_del hostdev6
    - device_del scsi0
 - QMP commands (failing)
    - device_del scsi0

Libvirt:
 - Note: A preventative fix went into Libvirt 2.5.0
   (libvirt commit 655429a0d4a5 ("qemu: Prevent detaching SCSI controller used by hostdev"))
 - Include the following XML
    # cat scsicontroller.xml 
        <controller type='scsi' model='virtio-scsi' index='0'/>
    # cat scsihostdev.xml 
        <hostdev mode='subsystem' type='scsi'>
          <source>
            <adapter name='scsi_host6'/>
            <address bus='0' target='6' unit='1074151456'/>
          </source>
        </hostdev>
 - virsh commands (working)
    - virsh detach-device guest scsihostdev.xml
    - virsh detach-device guest scsicontroller.xml
 - virsh commands (failing)
    - virsh detach-device guest scsicontroller.xml

v1->v2:
 - Hold vq_lock across virtscsi_complete_cmd call (Fam Zheng)

Eric Farman (1):
  virtio_scsi: Reject commands when virtqueue is broken

 drivers/scsi/virtio_scsi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
1.9.1

