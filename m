From: Michel Meyers <steltek@tcnnet.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector
 blacklist
Date: Wed, 20 Apr 2016 10:46:45 +0200
Message-ID: <571741F5.7060305@tcnnet.com>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
 <570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
 <570CB1C8.5050106@tcnnet.com> <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
 <570D4A19.40000@redhat.com> <yq137qqzl6f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smail.vo.lu ([80.90.45.96]:55500 "EHLO smail.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbcDTIrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2016 04:47:11 -0400
In-Reply-To: <yq137qqzl6f.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 2016-04-12 21:22, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:
> 
>>> Mike: Any preference?
> 
> Mike> I think quirking SYNOLOGY is best. It will be the safest route and
> Mike> work for all devices.
> 
> Michel: Please spin a new version of the patch.

Apologies for not getting back earlier. SYNOLOGY have released a new
version of their OS indicating that they have worked to fix the iSCSI
problem (and another one to actually make that update installable):

https://www.synology.com/en-global/releaseNote/RS10613xs+
- "Fixed multiple issues that might cause iSCSI service to hang under
heavy loading and performing Vmware VAAI commands."
- "Fixed an issue where DSM 6.0-7321 Update 1 could not be normally
installed with Auto-Update."

(They have not updated my support ticket on this case thus far.)

Both my SYNOLOGY appliances now seem to show correct vpd data when queried:

root@server:/# sg_vpd -p bl /dev/sdb
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 1
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 128 blocks
  Maximum transfer length: 8192 blocks
  Optimal transfer length: 1152 blocks
  Maximum prefetch length: 0 blocks

root@server:/# sg_vpd -p bl /dev/sdd
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 1
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 128 blocks
  Maximum transfer length: 8192 blocks
  Optimal transfer length: 512 blocks
  Maximum prefetch length: 0 blocks

I am currently running tests with an unmodified Debian 4.4.0-1-amd64
kernel, so unless I can reproduce the problem, I suggest we leave the
current blacklist as is (thereby only quirking the pre-6.0 SYNOLOGY
volumes that are affected) and discard the new patch.

--
Michel

