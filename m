From: Ravi Parimi <rparimi@gmail.com>
Subject: question about SG_ ioctls
Date: Tue, 27 Sep 2005 19:12:00 -0700
Message-ID: <21c20ce70509271912142ef77@mail.gmail.com>
Reply-To: Ravi Parimi <rparimi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.197]:22559 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S965250AbVI1CMB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 22:12:01 -0400
Received: by zproxy.gmail.com with SMTP id 13so537270nzn
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2005 19:12:00 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a SCSI controller thats need to be tested for correct
performance with all the SG_ and SCSI_ ioctls. I've been using the
sg3_utils package to do this so far. The various programs in sg3_utils
issue calls to different ioctls depending on the command line
arguments passed onto them. I would like to have just one program that
issues calls to a few IOCTLs that I really care about, and want to
calls to these IOCTLs lined up in a C program like this:

===================================================================
   if ((res = ioctl(sg_fd, SG_GET_VERSION_NUM, &ver) < 0)) {
      printf("IOCTL SG_GET_VERSION_NUM failed\n");
      return 1;
   }
   printf("SG_GET_VERSION_NUM:\n");
   printf("\tversion = %d\n", ver);

   if ((res = ioctl(sg_fd, SCSI_IOCTL_GET_IDLUN, &my_idlun) < 0)) {
      printf("IOCTL SCSI_IOCTL_GET_IDLUN failed\n");
      return 1;
   }
   printf("SCSI_IOCTL_GET_IDLUN:\n");
   printf("\tchannel = %d\n\tid = %d\t\n\tlun = %d\n",
   (my_idlun.dev_id >> 16) & 0xff, my_idlun.dev_id & 0xff,
   (my_idlun.dev_id >> 8) & 0xff);
===================================================================

I want to know if doing the above is OK? I do not know if calling
certain IOCTLs in a specific order has any problems/issues. Also, if
the above program reports success for all the IOCTLs called, it is
safe to assume that the scsi controller is able to handle all IOCTLs
properly?

Thanks a lot,
--ravi
