From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v1 2/2] genirq: support multiple IRQ notifier.
Date: Sat, 26 Mar 2016 01:05:01 +0800
Message-ID: <201603260102.KVPvkrJK%fengguang.wu@intel.com>
References: <150f84b627280fa9d4397e6a4cdb5d096bef70bd.1458920770.git.weongyo.linux@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150f84b627280fa9d4397e6a4cdb5d096bef70bd.1458920770.git.weongyo.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Weongyo Jeong <weongyo.linux@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Mike Marciniszyn <infinipath@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Weongyo,

[auto build test WARNING on tip/irq/core]
[also build test WARNING on v4.5 next-20160324]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Weongyo-Jeong/genirq-support-multiple-IRQ-notifier/20160325-235708
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

>> include/linux/interrupt.h:224: warning: No description found for parameter 'list'
   kernel/irq/handle.c:1: warning: no structured comments found

vim +/list +224 include/linux/interrupt.h

f0ba3d05c Eyal Perry         2014-05-20  208   * @kref:		Reference count, for internal use
f0ba3d05c Eyal Perry         2014-05-20  209   * @work:		Work item, for internal use
f0ba3d05c Eyal Perry         2014-05-20  210   * @notify:		Function to be called on change.  This will be
f0ba3d05c Eyal Perry         2014-05-20  211   *			called in process context.
f0ba3d05c Eyal Perry         2014-05-20  212   * @release:		Function to be called on release.  This will be
f0ba3d05c Eyal Perry         2014-05-20  213   *			called in process context.  Once registered, the
f0ba3d05c Eyal Perry         2014-05-20  214   *			structure must only be freed when this function is
f0ba3d05c Eyal Perry         2014-05-20  215   *			called or later.
f0ba3d05c Eyal Perry         2014-05-20  216   */
f0ba3d05c Eyal Perry         2014-05-20  217  struct irq_affinity_notify {
f0ba3d05c Eyal Perry         2014-05-20  218  	unsigned int irq;
f0ba3d05c Eyal Perry         2014-05-20  219  	struct kref kref;
f0ba3d05c Eyal Perry         2014-05-20  220  	struct work_struct work;
f0ba3d05c Eyal Perry         2014-05-20  221  	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
f0ba3d05c Eyal Perry         2014-05-20  222  	void (*release)(struct kref *ref);
3fb671e48 Weongyo Jeong      2016-03-25  223  	struct list_head list;
f0ba3d05c Eyal Perry         2014-05-20 @224  };
f0ba3d05c Eyal Perry         2014-05-20  225  
0244ad004 Martin Schwidefsky 2013-08-30  226  #if defined(CONFIG_SMP)
d7b906897 Russell King       2008-04-17  227  
d036e67b4 Rusty Russell      2009-01-01  228  extern cpumask_var_t irq_default_affinity;
184047567 Max Krasnyansky    2008-05-29  229  
01f8fa4f0 Thomas Gleixner    2014-04-16  230  /* Internal implementation. Use the helpers below */
01f8fa4f0 Thomas Gleixner    2014-04-16  231  extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
01f8fa4f0 Thomas Gleixner    2014-04-16  232  			      bool force);

:::::: The code at line 224 was first introduced by commit
:::::: f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de genirq: Provide !SMP stub for irq_set_affinity_notifier()

:::::: TO: Eyal Perry <eyalpe@mellanox.com>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--0OAP2g/MAC+5xKAE
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICDts9VYAAy5jb25maWcAjFxbc9s4sn7fX8HKnoeZqpOb7XgzdcoPEAmKGBEkQ4CS7BeW
RqYT1diSV5eZ5N+fboAUbw1ltmpqY3QDBBqNry9o6N//+rfHTsfdy+q4Wa+en394X6tttV8d
q0fvafNc/Z8XpF6Sao8HQr8D5nizPX1/v7n+fOvdvPv07sPb/fo/3qzab6tnz99tnzZfT9B7
s9v+69/A7adJKKbl7c1EaG9z8La7o3eojv+q25efb8vrq7sfnb/bP0SidF74WqRJGXA/DXje
EtNCZ4UuwzSXTN+9qZ6frq/e4qzeNBws9yPoF9o/796s9utv779/vn2/NrM8mDWUj9WT/fvc
L079WcCzUhVZlua6/aTSzJ/pnPl8TJOyaP8wX5aSZWWeBCWsXJVSJHefL9HZ8u7jLc3gpzJj
+qfj9Nh6wyWcB6WaloFkZcyTqY7auU55wnPhl0IxpI8J0YKLaaSHq2P3ZcTmvMz8Mgz8lpov
FJfl0o+mLAhKFk/TXOhIjsf1WSwmOdMc9ihm94PxI6ZKPyvKHGhLisb8iJexSGAvxANvOcyk
FNdFVmY8N2OwnHfWZYTRkLicwF+hyJUu/ahIZg6+jE05zWZnJCY8T5jR1CxVSkxiPmBRhco4
7JKDvGCJLqMCvpJJ2KsI5kxxGOGx2HDqeDL6htFKVaaZFhLEEsAZAhmJZOriDPikmJrlsRgU
v3cS4WSWMXu4L6dquF6rE6UfxgyIb94+IXS8Paz+qh7fVuvvXr/h8fsb+utFlqcT3hk9FMuS
szy+h79LyTtqk001A7GB/s55rO6umvbzAQdlUAAE7583f7x/2T2enqvD+/8pEiY5KhFnir9/
NzjpIv9SLtK8s5uTQsQByI6XfGm/p+wxN2A2Ncj4jAB2eoWWplOeznhSwoyVzLrwJXTJkzms
GScnhb67Pk/bz0EPzJEVoAtv3rRQWbeVmisKMWGTWDznuQJd6/XrEkpW6JTobA7HDFSVx+X0
QWSDY1NTJkC5oknxQxciupTlg6tH6iLctIT+nM5r6k6ou5whA07rEn35cLl3epl8Q4gS9I4V
MZzZVGlUsrs3v2x32+rXzo6oezUXmU+ObfcfNDzN70umwbJEJF8YsSSIOUkrFAcIdW2zOWms
AKsN8wDViBstBq33Dqc/Dj8Ox+ql1eKzIYBDYY4lYSOApKJ00dFxaAET7APS6AhgNuhBjcpY
rjgytW0+mleVFtAHIE37UZAOwanLEjDN6M5zsB8Bmo+YISrf+zExY3OU560AhjYIxwNASbS6
SESzW7Lg90Jpgk+miGQ4l0bEevNS7Q+UlKMHtCkiDYTfVfQkRYpw7bQhk5QIcBjwTZmV5qrL
Y/2vrHivV4c/vSNMyVttH73DcXU8eKv1enfaHjfbr+3ctPBn1mD6flok2u7l+VO410aeLXn0
udwvPDVeNfDel0DrDgd/AsiCMCiUUwNmzdRMYRdSCDgUOGdxjOAp04Rk0jnnhtN4cM5xcEpw
Zng5SVNNchkbAW5WckUfbTGz/3AdzALcWmtawIUJrJp11+pP87TIFA0bEfdnWSrAFYBN12lO
L8SOjEbAjEUvFr0ueoHxDOBtbgxYHtDz8M8+Bp5/44MR62UJ2CKRgOeuBkagEMHHjquPJ1TH
IHyfZ8aLMps06JP5KpvlZRYzjW5/S7Vq1JWhBGgWgI85LR5wniRoVFkDA810r0J1kWMGBHUv
6Z3KctikmUOBpnSX/vrovuDHlGHhmFFYaL4kKTxLXesU04TFIb3PBlUcNAONDtokCy8LNwLT
R1KYoI0xC+YCll4PSsscN9xYZces4JsTlueirxbNcjAUCHgwVDoYsjybCANydbCbVfun3f5l
tV1XHv+r2gKqMsBXH3EV0L9Fv/4Q59nUrjcSYeLlXBoPnJz4XNr+pQHeAc73PEcMAHNa7VTM
KGdBxcWkOy0VpxPXgdAQ2qFFLsHPFKHwTcTjUP80FPHARHTlmlqOzhlvWspECqt43Wn9XsgM
TP2E0wpVRxK0jcTvmQwExKOg7QiNvs+Vcs2Nh7A2gfKG+KHXY+Cp4L6hOQD7Vk7Ugg0dagEA
jeE5TE4PSLNh6GNbc65JAqAt3cG2YvARUphppmkIUZrOBkTMB8DfWkyLtCA8IAhnjE9S+3ZE
QAoB5D14v+hpGTw1+ZrBV3I+VWAJAps/qQVZskwQs4FWey4GtGgBas2ZNX0DmhRL2J+WrMwX
h/YGoAHadZEn4E1pUN5uMml40lEFKSoxcHN+83p5QSGHWmCk1ervKJsxtyqvWMjBmcwwdzIc
oVZCK18Trg846n42CnTQgrRwJB4gSimtr95ElsQKFPcRYSBGj/VIeOAQmPWjpnMfHJOeRzMk
EgdvxAPblPCLo+B2FDGjbfyYG4SXuvGI8G4dRynBsIbX6Zr+Vsg0KGI4jYgLPEZ9Ge+2shQ4
EKkcZ67GqcFLacU2FWg3Ic3u67Na6rjTE3zMBJAKxLFgedAhpODJggNQJ6euRwRmsq/n/Ief
zt/+sTpUj96f1ga+7ndPm+deFHFeJnKXDab3wi8z2QZkLAhFHEXaScSgn6PQJN597BhwK19i
DxvJGy8/BqgreomECTrZRDeTHoMPZQDgRYJM/Wi1phuJWvolGtl3kWM04ejcJfZ79xNlTKcI
srlcDDhQ074UvEBwgEWY+NjNki8ahtZlBIE99B0is9fZfreuDofd3jv+eLWR41O1Op721aGb
2H9AxQoc2RewH2Q75hZDzgCMAfmYdJhtw4WxfcOKGTE3K19qUGHM2V7yn+u0psgFPZKNnEDY
8Nkcc4fGpDjiiOge0B/cUgCXaUGn6yByx0DSpjJbPb75fEt7qJ8uELSivUOkSbmkTsWtuU9p
OeGUQ1wkhaAHOpMv02nRNtQbmjpzLGz2H0f7Z7rdzwuV0mGvNI4bd7ikciESPwJT55hITb52
xQ4xc4w75RDgTpcfL1DLmA7LpH+fi6VT3nPB/OuSTn0aokN2Pvidjl6IJM6TUWOy46LOHAQM
5uvbFxWJUN996rLEHwe03vAZWAM4zYlP5QqQAaHKMJk8hyo6MT6S4QD0G2rP5vZm2JzO+y1S
JEIW0mS3QvBX4/v+vI3P6etYqp7jAlNBZxWdBx6DF0H5LTAiwLQRTsfENc1mf3tXnA2FyYBg
hyPEinxMMH6H5BB6UWMV0rftLTRlXNsgitzsQAoKrMxllwKLe14/5zLTI1esaZ+nMbhKLKfz
SDWXU9tQCJmgMc1smiNNZxSNg29yD4GxAy+dBJ2Cak5oeyU+05EzfjDniOOhWLpSc2bGiha3
UcqsEDS0JClmcQcJkWYfLeWml4mtG29vKG92LlUWg/m67nVpWzGUdIjMslzR2amW/NMRPlLz
MleoaRgqru8+fPc/2P8N1jlwXUIw5dBa8oQRN6omYnGTzYltrljAP+weTxGjAsWNdcfLhILf
nWdzsW8zKcmSwsRarfNwnpGlEVKoO/dHKw2o2n6d4LEdDiIZLTrYZ+NeLid9p7LXXA/aHdBW
RAjlQxDQ7d7PlNT+CiBamJpBqKSR2edMmw8ZzLgZ5KF8d2oougeHNgjyUjvrQhq3EsUzbfdl
LnJANXCpip4PO1PU0Wlu6EzEZC9wgvzu5sNvt91LgXE4RwFjtxZg1nPl/JizxNg8Ogx1uMYP
WZrSmayHSUHDxIMaZwhrUhNLmavzJuvkvvIPeZ73swkm1z+EmEy78dcYaIhBU7zEzvMiG253
DzoVuMkYli3ubjt6InVOw6WZr42QnRMAYbiDC2OMwSGlna46kUG79A/lxw8fKCB+KK8+feiJ
6KG87rMORqGHuYNhhvFGlOPdG33JwJfcdYXMVGTyTRTawiETPiAcQEeOgPuxxtvu/U/qM3MT
dam/ST1B/6tB9zrZPA8Una/3ZWAi3IlLzwFVRXhfxoGmbgq6mmDhvUHjKNVZbBKENk7d/V3t
vZfVdvW1eqm2RxOpMj8T3u4Vq9B60Wqd56BhidY1FfY8peZS1Qv31X9P1Xb9wzusV3UGpF08
upk5/0L2FI/P1ZDZefNrBIDwo858eAmQxTwYDT45HZpFe79kvvCq4/rdr91PYSORBLGlX3VK
tvWGlCOq91EZSFIaO8odQIvos5hw/enTBzp0ynw0VG4EuFfhZCQE/r1an46rP54rU77omSua
48F77/GX0/NqpBITMHNSY06OvsiyZOXnIqMMlU3apUUPPOtO2HxpUCkcAT2Gb45zbb9ns0Ei
tSjfFeZIHkH112ZdecF+85e9lGormTbrutlLx0elsBdOEY8zVwzB51pmoSOPogG+GaYdXaGB
GT4UuVyA+bWX6iRruADDwQLHJNAiLsxtNSW0wV1bkIu5czGGgc9zRzYKtK2T7yFZzgUhcFBh
JOGTmcouF97QN7U2ndiM2QLAAKQShkRuDg/6o9nX3pZJTUswDYlp2GSyqeJr6jjBD6qLWtt9
sk2jGcjNYU1NATZA3mMik5wIRP5xqjCVhw7BUD6tqHNGY7F/RU6Gc5Ch9A6n19fd/tidjqWU
v137y9tRN119Xx08sT0c96cXc317+LbaV4/ecb/aHnAoD3C98h5hrZtX/GdzetjzsdqvvDCb
MgCZ/cvf0M173P29fd6tHj1bfNjwiu2xevbguJpds+etoSlfhERz2yXaHY5Oor/aP1IDOvl3
r+ecrjqujpUnW6v5i58q+WsHJloZ+pHDwi9jk6Z3Euv6OTArThbOIxfIieBcTqV8JWpt6+zy
2Rwpgc5ELxDDNldWWjIf/MMUfSeDB+OiKbF9PR3HH2wtY5IVYzWMYD+MJoj3qYdd+q4HVn39
s3NoWLvLmTLJSc33QWFXa1BG6ixqTadlAJpcxRdAmrloIpOitNWIjmz44pLPnsxdpzrzP//n
+vZ7Oc0cpR+J8t1EmNHUBiPubJf24T+HfweBgj+8HLJKcOWTe++o+lIOLVeZpAmRGjuWWaao
b2bZWEexrX6psTOlhk0vS9WZt37erf8cEvjWuEbg3mPpKPrK4DRgDTR6/EaEYLllhoUbxx18
rfKO3ypv9fi4QQ9h9WxHPbwb3PeZW+TUBIEQM+BmwfA9FbZNpCQWDvcvXeCtOoStsSO/aBgw
uqTdLEtnc0dVyMJZKRjxXDI6amlKVqmciJp0q/stcu22m/XBU5vnzXq39Sar9Z+vz6ttz/+H
fsRoEx/cgOFwkz0YmPXuxTu8VuvNEzhwTE5Yz50dJBystT49HzdPp+0a97DBtccx1MswMG4U
DZtIzCHed4SjkUYPAoLGa2f3GZeZw8tDstS31785bjSArKQrUGCT5acPHy5PHWNM18UQkLUo
mby+/rTESwYWOC7akFE6gMgWI2iHbyh5IFiTgxlt0HS/ev2GikIc/qB/k2lI4X71Unl/nJ6e
APqDMfSH9EHDAoDYmJrYD6jJtJncKcOco6O6NC36MXQTMsABSCNflLHQGuJUiLQF65SSIH30
cAobzyUDkd8z44Uax3fYZnyzx35Eg+3Ztx8HfMTmxasfaBPHGo5fA6BzpOEzQ1/6XMxJDqRO
WTB14E2xoMUupUOduFTOvE/CIe6BsJ9WeFNDJSYCJH1P7AQPmN9EiRC6Fp2HQobU7kLr5kE7
MVIOp3oA5djkx0zRUwOvi4h92pkXy0CozFV6XDgOl0n8uty1+WYPwEZtN3YTKWxAf9g6hFnv
d4fd09GLfrxW+7dz7+upAnebOIJwFKaDUsZeJqKpOKCivtbdjSAU4Wfe8TLO/qN63WyN7R6o
uG8a1e6078F3M348U7lfis9Xnzp1PNAKYTrROomDc2u7O1qCw54JWr/BYzY+VunLnzBIXdDX
z2cOLelSfi5rBjgZDu9dxJOUTiaJVMrCCbJ59bI7VhgDUaqiNDcXPbLM8dZ33Pv15fB1uCMK
GH9R5rGDl27BHd+8/traZiKYUkWyFO4AF8YrHevOjHYNk4qt3Jbaad5M3pQWmOO4ZQvqQoWB
hk8BUSRblknercsSGZY+Tgpa842HZgpN8zR2RQ+hHMsckbr7mmSUaXFBOfqy2ZKVV58TiY42
jb89LsB2WmXBoypn4NYaDvcX0df0HVcS0h/bsW71+At4ieDFU9CTszFQsO3jfrd57LJB3JWn
rutlZ7intLPdZnKc1PoNFrSo1JG5tncwOhpN36RNei/FYZNHCzdco65NsoXKUwSO/GGTYgQp
uO6MAh7HZT6hISnwgwmjNXuaptOYnz9BzBdiLau+HaQObIkMRF2dsvJ2vgrdfrEEkuORB9ZT
YsjqMkmhMhXOjuj/Ak1YWul8OBOyC72/FKmmMy6G4mt6OZgDDdVN6Ugkh1gT5KCl4A6AJzEg
W6VYrb8NfGI1uqW1B/FQnR535rKg3an2XIMtcH3e0PxIxEHOaejFDJgrQY7Pi+hAyr7tvkwt
hzfVrZ9h/g+0yDEA3joYHbLvOWimJB6LtH728g1i2P6zQfOLCCL/Yh6Dd3xL0+t1v9ke/zSZ
hseXCkxoey13tk9K4RV0jGdpDphRX9zf3dRbuXt5hc15a14wwq6u/zyY4da2fU9d9Nl0PlYw
0NbS3ijCmcVflshy7kOs43jlVF8+FubpPyeriG2lKI529/HD1U0XKnORlUwBYLreiWH5sPkC
UzQYFwmcAIxf5SR1vHuypTWL5OLdRkhdRkQcb1aUXdn4cZLi9tc3QGckJj5oTR4wWbGmSUxF
Jm22qFdeOyhJ/lnhbb2i1Dwi5mzW1GY4PEZ0WkDb+7cSvaFsqrrRWQme4v4HBNZ/nL5+HVzt
GlmbWmPlKnAZ/KbCBZ508jsIz/kOqZ4bGK4YFjnenoZy4Qv2UUqhXGhhueaudLAhQhBVONJh
lqO+mccakgtcF4rc2sWa+SKuh7F5Z04tpyG7RjI6hrIZafW58ZLEosH1VX2NCrrgxRCAnV4t
/ESr7dce5qBJLjIYZfzGpfMJJAKIJ/ZNM51j/EKmGTsqmIBCw4lL04zSnR59WNpmiRhj4aX1
qBLFCZmWbNUJf8fkZ2LEL8w4z6hX4ijG9nR5vxzqgPfwv97L6Vh9r+AfWLvwrl+9UO9P/czh
kj7iM1hHGG45FgvLhK8dFxnTNLJZXlPj5j7J4AXML/tjZgBMp134SJOsiUFkP5kLfMa8k1M8
Dt1PIsxHQQ3PLyccvnzzk0YXPjqzMHVpWsIxfg2F4mccipacJTbv9S5tqJ/zAJ8fMMJxwZ8N
oLHcbJ3rVwXqX6/AHwW4ZIt+KmPzmwP/iOnyDxN8qX+t55Ja17/GUeZuc9hIs+R5nuZw4H/n
7lpNW0FJ8nQNOuZuG4CGuFzbB5HmOZqt5KeQnGQkvtA+rnT89pYB/bBI/PaXA4bPE8/Uac6y
6B/xhJnZreEj1fq5K/nYtk8sF0JH1JPRmizNO0Ng8CEQHLDUFXF2ovZV6/DBZd3RjtISsQci
BJHiDUcKZo8H/g4IuNa6OhwHBwQFYI6u+RkkOj3S7gu+a3Qr+MQ8zXPSLQDe3pxhjT5sOKGI
L52FPoYBdSuZ1rVLNGoYvhkwakcu0TCYH3GgC8MMPQfFj1wllPZ3QoLUV3nvt15675zdYxeB
8wc6wItxIzqTGf1EsuMbTYNeRh//vnS0i4liCYwM/h3+4Id9y9kGKEi9jAxzU0/+/31cTW+D
MAz9S+162RVS0LwhiiCtSi9om3roaRJaD/v3sx2aD2rnyjOFksR2HL83uG6tKm3VcH4g05RA
FXbM+MrD4HrTFT0T1/uckd3gSr2lmaOfFAabjJftD6SBIBswxZq9Zi43wt19cxzkpGMpYuNq
0QUK6EBDcYZwcHp6kx27atqcXzch91tjOBJbGXOTL6ispSjTgXZPGD8sbiANgLK59haZye5t
2lUzof+kS5CKXzFObE1XZNaal7F5KOVlxg0TDKWQ7jlkC1WDu/velKphMK6VGN0dSTuOXOLz
m7uDh+v3fb79/km1j49qVEpOlTn2YEf0QNXAZXlee1lbsWrw+OThB4uInLJGU3W7fuwy0nSn
hFux7DzhouuMlNAW/Sg4arfRuH3Nn7iTn3/uGNquUdHJS1zYvjWYfdTUJ0iZhqCCgSZN1Spo
De1DQLIEQR2sM+AbdVeQelnQDGAiNKsadQ2kyiimx+lmwMoDiehWZsLRfXa72YMc4AgGi1mp
hu7k8xJE5B6OBkq+S2MzGJnwyxJ2izCc4xwILNWQZnAH2u4ln0acLyQom4Gm0ryLk3SgUYv5
W+4S+eCUa8WBLxZL9EPpMx16DtRc7bdwSrUuMLNT/uF+L+9DWLdPFXlaKFu5MD3QGXUBrfDK
FG8mDlkI/gNjGVGPMlgAAA==

--0OAP2g/MAC+5xKAE--
