From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/23] sd: handle REQ_UNMAP
Date: Thu, 30 Mar 2017 11:28:32 -0400
Message-ID: <yq1h92a3hsv.fsf@oracle.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323143341.31549-13-hch@lst.de>
	<1490719722.2573.8.camel@sandisk.com> <20170330090201.GD12015@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20170330090201.GD12015-jcswGhMUV9g@public.gmane.org> (hch-jcswGhMUV9g@public.gmane.org's message of "Thu, 30
	Mar 2017 11:02:01 +0200")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: "hch@lst.de" <hch-jcswGhMUV9g@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org" <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, "shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

ImhjaEBsc3QuZGUiIDxoY2hAbHN0LmRlPiB3cml0ZXM6CgpDaHJpc3RvcGgsCgo+IE9uIFR1ZSwg
TWFyIDI4LCAyMDE3IGF0IDA0OjQ4OjU1UE0gKzAwMDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToK
Pj4gPiAgCWlmIChzZHAtPm5vX3dyaXRlX3NhbWUpCj4+ID4gIAkJcmV0dXJuIEJMS1BSRVBfSU5W
QUxJRDsKPj4gPiAgCWlmIChzZGtwLT53czE2IHx8IHNlY3RvciA+IDB4ZmZmZmZmZmYgfHwgbnJf
c2VjdG9ycyA+IDB4ZmZmZikKPj4gCj4+IFVzZXJzIGNhbiBjaGFuZ2UgdGhlIHByb3Zpc2lvbmlu
ZyBtb2RlIGZyb20gdXNlciBzcGFjZSBmcm9twqBTRF9MQlBfV1MxNiBpbnRvCj4+IFNEX0xCUF9X
UzEwIHNvIEknbSBub3Qgc3VyZSBpdCdzIHNhZmUgdG8gc2tpcCB0aGUgKHNka3AtPndzMTYgfHwg
c2VjdG9yID4KPj4gMHhmZmZmZmZmZiB8fCBucl9zZWN0b3JzID4gMHhmZmZmKSBjaGVjayBpZiBS
RVFfVU5NQVAgaXMgc2V0Lgo+Cj4gVGhleSBjYW4sIGFuZCBpZiB0aGUgZGV2aWNlIGhhcyB0b28g
bWFueSBzZWN0b3JzIHRoYXQgd2lsbCBhbHJlYWR5IGNhdXNlCj4gZGlzY2FyZCB0byBmYWlsLAoK
SSdtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB3aGF0IHlvdSBtZWFuIGJ5IHRoYXQ/CgotLSAKTWFy
dGluIEsuIFBldGVyc2VuCU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZwpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmJkLWRldiBtYWlsaW5nIGxpc3QKZHJi
ZC1kZXZAbGlzdHMubGluYml0LmNvbQpodHRwOi8vbGlzdHMubGluYml0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RyYmQtZGV2Cg==
