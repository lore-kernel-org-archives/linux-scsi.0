From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 12/13] iscsi-target: Add misc utility logic
Date: Thu, 28 Jul 2011 13:19:13 -0700
Message-ID: <1311884353.6931.206.camel@haakon2.linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-13-git-send-email-nab@linux-iscsi.org>
	 <CAJAFBLCJVLA7RwmVBUPobzqV+j5T5GoV=uRoRqUDuQkJn41Qpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54243 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1G1U2e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 16:28:34 -0400
In-Reply-To: <CAJAFBLCJVLA7RwmVBUPobzqV+j5T5GoV=uRoRqUDuQkJn41Qpw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>

On Thu, 2011-07-28 at 13:30 +0200, Fubo Chen wrote:
> On Sat, Jul 23, 2011 at 10:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > +static int iscsit_do_rx_data(
> > +       struct iscsi_conn *conn,
> > +       struct iscsi_data_count *count)
> > +{
> > +       int data = count->data_length, rx_loop = 0, total_rx = 0, iov_len;
> > +       u32 rx_marker_val[count->ss_marker_count], rx_marker_iov = 0;
> > +       struct kvec iov[count->ss_iov_count], *iov_p;
> 
> How big can count->ss_iov_count be ? Can this make a stack overflow ?
> 

This is set to zero when OFMarker and IFMarker are explictly disabled
(the default), which is the case for the vast majority of initiators.

When this is enabled, the smallest this value for OFMarkInt and
IFMarkInt can be is 512 bytes, which on 64-bit with a 131072
MaxRecvDataSegmentLength would mean 3k of stack usage for iov[] above..

In the end it might may more sense to just remove the OFMarker and
IFMarker alltogether code than to worry about dynamic allocation here.

--nab

