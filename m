From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: qla4xxx : Driver v5.00.05b4-k - RFC requested!!!
Date: Thu, 9 Mar 2006 13:23:58 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06F604AE@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56167 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751608AbWCIVYC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 16:24:02 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All,

For the upstream inclusion of qla4xxx driver, following files :

- Updated driver source (qla4xxx-src-v5.00.05b4-k_submit.tar.bz2)
- Driver patch (patch-qla4xxx-5.00.05b4-k-scsi-rc-fix-2.6.16-rc3)
- License.qla4xxx 

has been uploaded at the following ftp location for further review :

 ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b4-k

This driver has been build and tested against linux-scsi-rc-fixes tree.
To compile this driver you need the "use_sid.patch" from Mark Christie
as well. This patch has been uploaded in the above ftp location.

It currently supports QLogic ISP4010 and ISP4022 products. This is basically based on driver v5.00.03b15-k initially submitted by Andrew Vasquez :

http://marc.theaimsgroup.com/?l=linux-scsi&m=112604454018433&w=2

Significant Changes to this release are :

-  Added the code to register iscsi transport functions. Since a lot of
   functionality like session creation or destruction etc is handled
   by our Firmware, we are working on proposing the required changes needed
   to the open-iscsi/iscsi_transport interface for our Applications
   to be able to use these interfaces.
           
- Create iscsi session & connection for each of the target 
  discovered by the HBA Firmware. qla4xxx driver is based on one of the 
  patch send out by Mike Christie to store driver specific stuff in the
  iscsi_cls_session, similar to what rport provides for FC. The 
  link to that patch is provided later in this email.

- Stripped out the iSNS functionality as suggested and let be in user space.
  Again this will require some modification to open-iscsi/iscsi_transport 
  to support iSCSI HBA, as this functionality is handled in the Firmware.
  Details will follow later.
  
- Incorporated the updated license from qla2xxx (License.qla4xxx).

- Additional API interface changes, including kthread creation.
 
- Bug fixes have being ported over from our latest QLogic std driver.

Our ultimate goal is to be able to fit in with the open-iscsi architecture 
and leverage the functionality it provides.

The driver patch - patch-qla4xxx-scsi-rc-tree-2.6.16-rc3 build against scsi-rc-fixes tree can be applied as follows :

# cd /usr/src/linux-scsi-rc-fixes-2.6.git
# patch -p1 < <path_to_qla4xxx_patch_file>

Additional work that need to be done inconjuction to what I have
already outlined earlier :

- Add the iscsi block/unblock stuff. 
- Add support for SYSFS attributes
- Expand the uevent for passing event up needed for the iSCSI HBA.
- Additional cleanup etc.

If needed we can split the driver patch into subset of patches.

Looking forward to Comments/Criticisms/Suggestions.

Regards
Ravi Anand
QLogic Corporation


 
  





















