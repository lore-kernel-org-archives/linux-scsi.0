From: "goggin, edward" <egoggin@emc.com>
Subject: RE: [SCSI BUG 2.6.15-rc3-mm1] scheduling while atomic on boot tim
	 e
Date: Tue, 6 Dec 2005 22:13:13 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AE8D@srmanning.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030264AbVLGDNu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "goggin, edward" <egoggin@emc.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, Wu Fengguang <wfg@mail.ustc.edu.cn>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Monday, December 05, 2005 3:32 PM
> To: goggin, edward
> Cc: 'Andrew Morton'; Wu Fengguang; 
> linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: RE: [SCSI BUG 2.6.15-rc3-mm1] scheduling while 
> atomic on boot tim e
> 
> On Fri, 2005-12-02 at 15:35 -0500, goggin, edward wrote:
> > I think this is caused by my patch to scsi_next_command()
> > (on or about 11/11) causing it to call put_device() and
> > invoke the kobject's release() function while in soft
> > interrupt.  My patch should be removed ... although I
> > don't have an alternate solution in mind for the original
> > problem which was an "oops with USB Storage on 2.6.14".
> 
> Yes and no.
> 
> Reverting your patch won't fix the problem because scsi_put_command()
> will then relinquish the last reference to the device and trigger the
> same warning.  Additionally, blk_run_queue now stands a good chance of
> running on a freed queue which could trigger a panic.
> 
> The problem seems to be that device_del() is apparently requiring user
> context, if that's true, this will bite us not only here, but all over
> the place ... in fact the fix might have to be to do the target reap
> through a workqueue.

How about extending kobject_cleanup() to queue to a workqueue if
requested to do so?  Doing so would provide an easy mechanism for
other cases to utilize and they could all share the same workqueue.
Scsi would request certainly request this feature for calls to
scsi_device_dev_release() for its device kobjects.
 
> 
> Regardless, your patch isn't the culprit here, it's just the 
> thing which
> is doing the last put.
> 
> James
> 
> 
> 
